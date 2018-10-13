local Parser = require 'pascal'

local function getInput(filename)
	local input = ''
	for line in io.lines(filename) do
		input = input..line..'\n'
	end
	return input
end

local function check(input)
	local ast, err, err_pos, errors = Parser.parse(input)

	print('Erros encotrados: '..#errors)
	for k,_error in pairs(errors) do
		print(' '..k..'. (linha: '.._error.line..', coluna: '.._error.col .. '): '.._error.msg )
	end

	if ast then
		io.write('Resultado: ')
		print 'Ok'
	else
		print('Erro não capturado: (linha: '..err_pos.row..', coluna: '..err_pos.col..')')
	end
end

for line in io.lines('programs/labelTests/tests.txt') do
	if #line == 0 then
		break
	end

	print ('Testando \''..line..'\':')
	check(getInput('programs/labelTests/'..line))
	print ''
end