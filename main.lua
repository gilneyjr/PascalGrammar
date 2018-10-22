local Parser = require 'pascal'

print(package.path)

local function getInput(filename)
	local input = ''
	for line in io.lines(filename) do
		input = input..line..'\n'
	end
	return input
end

local function mySplit(str)
	local tab = {}
	for i in string.gmatch(str, "%S+") do
		table.insert(tab,i)
	end
	return {file=tab[1], err=tab[2]}
end

local function checkLabel(input, expectedErr)
	local ast, err, err_pos = Parser.parse(input)
	assert(err == expectedErr, '\n\tLabel esperada: '.. expectedErr .. '\n\tLabel encontrada: '.. (err or 'nil'))
	print("  > " .. Parser.errinfo[err] .. ' (linha: ' .. err_pos.row .. ', coluna: '.. err_pos.col .. ')')
end

local function checkValid(input)
	local ast, err, err_pos = Parser.parse(input)
	if not ast then
		if err == 'fail' then
			print 'fail'
		else
			print("  > " .. Parser.errinfo[err] .. ' (linha: ' .. err_pos.row .. ', coluna: '.. err_pos.col .. ')')
		end
	end
	assert(ast)
	print 'Ok'
end


local cmd

if #arg > 0 then
	cmd = arg[1]
else
	print 'Atenção: Não foram fornecidos argumentos. Logo, o programa executará os testes de cada uma das labels.\n'
	cmd = 'label'
end

if cmd == 'label' then
	for line in io.lines('programs/labelTests/tests.txt') do
		if #line ~= 0 then
			local test = mySplit(line)

			print ('Testando \''..test.file..'\':')
			checkLabel(getInput('programs/labelTests/'..test.file), test.err)
			print ''
		end
	end
elseif cmd == 'valid' then
	for line in io.lines('programs/tests.txt') do
		if #line > 0 then
			io.write('Testando \''..line..'\': ')
			checkValid(getInput('programs/'..line))
		end
	end
else
	print 'Argumento inválido! Tente fornecer uma das seguintes opções:'
	print ' label'
	print ' valid\n'
end

