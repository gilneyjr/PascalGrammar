local Parser = require 'pascalv2'

local function getInput(filename)
	local input = ''
	for line in io.lines(filename) do
		input = input..line..'\n'
	end
	return input
end

local function check(input)
	local ast, err, err_pos = Parser.parse(input)

	if ast then
		print 'Ok'
	else
		print('Erro: (linha: '..err_pos.row..', coluna: '..err_pos.col..')')
	end
end

check(getInput('programs/teste.pas'))