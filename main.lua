local Parser = require 'pascal'

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

local function check(input, expectedErr)
	local ast, err, err_pos = Parser.parse(input)
	assert(err == expectedErr)
	print("  > " .. Parser.errinfo[err] .. ' (linha: ' .. err_pos.row .. ', coluna: '.. err_pos.col .. ')')
end

for line in io.lines('programs/labelTests/tests.txt') do
	if #line ~= 0 then
		local test = mySplit(line)

		print ('Testando \''..test.file..'\':')
		check(getInput('programs/labelTests/'..test.file), test.err)
		print ''
	end
end