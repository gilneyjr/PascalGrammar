local re = require 'relabel'

local function err(subject, pos, label)
	local line, col = re.calcline(subject,pos)
	print("line: "..line..",".."col: "..col)
	return true
end

local g = re.compile([[
	program 		<- head decs block Dot !.
	head			<- Sp PROGRAM Id (LPar ids RPar)^-1 Semi
	decs 			<- (varDecs / func / proc / labelDec / constDecs / typeDecs)*
	func  			<- FUNCTION Id (LPar formalParams RPar)^-1 Colon type Semi block Semi
	proc  			<- PROCEDURE Id (LPar formalParams RPar)^-1 Semi block Semi
	typeDecs 		<- TYPE (typeDec Semi)^+1
	typeDec 		<- Id Eq type
	labelDec 		<- LABEL labels Semi
	constDecs 		<- CONST (constDec Semi)^+1
	constDec 		<- Id (Colon type)^-1 Eq expr
	formalParams	<- varDec (Semi varDec)*
	varDecs 		<- VAR (varDec Semi)^+1
	varDec			<- ids Colon type
	ids	 			<- Id (Comma Id)*
	block			<- BEGIN stmts END
	stmts			<- stmt (Semi stmt)*
	assign			<- var Assign expr
	goto 			<- GOTO label
	labelStmt 		<- label Colon stmt
	if 				<- IF expr THEN stmt (ELSE stmt)^-1
	while			<- WHILE expr DO stmt
	for 			<- FOR assign (TO / DOWNTO) expr DO stmt
	repeat 			<- REPEAT stmts UNTIL expr
	call			<- Id LPar realParams^-1 RPar
	realParams 		<- expr (Comma expr)*
	label 			<- Id / UInt
	labels 			<- label (Comma label)*
	var 			<- Id ( LBrack realParams RBrack / Dot Id / Pointer )*

	type 			<- Pointer^-1 (simpleType / structedType)
	simpleType 		<- enumType / subrangeType / Id
	structedType 	<- PACKED^-1 (arrayType / recordType / setType / fileType)
	arrayType 		<- ARRAY LBrack simpleType RBrack OF type
	recordType 		<- RECORD (varDec Semi)^+1 END
	fileType 		<- FILE OF type
	setType 		<- SET OF simpleType
	enumType 		<- LPar (Id / assign) (Comma (Id / assign))* RPar
	subrangeType 	<- expr DotDot expr

	stmt 			<- (if / while / for / repeat / block / goto / assign / labelStmt / call / Id)^-1

	expr 			<- addExpr (RelOp addExpr)*
	addExpr 		<- multExpr (AddOp multExpr)*
	multExpr	 	<- unaryExpr (MultOp unaryExpr)*
	unaryExpr		<- UnaryOp* primaryExpr
	primaryExpr		<- NIL / call / UReal / UInt / String / var / LPar expr RPar

	RelOp 		<- ('<=' / '=' / '<>' / '>=' / '>' / '<') Sp
	AddOp		<- ('+' / '-'/ 'or' ![a-zA-Z_]) Sp
	MultOp 		<- ('*' / '/' / ('div' / 'mod' / 'and' / 'in') ![a-zA-Z_]) Sp
	UnaryOp		<- ('+' / '-' / 'not' ![a-zA-Z_]) Sp

	Asterisk	<- '*' Sp
	Assign 		<- ':=' Sp
	Colon 		<- ':' Sp
	Comma		<- ',' Sp
	Comments	<- (LPar Asterisk (!(Asterisk RPar) .)* Asterisk RPar / LCurBrack (!RCurBrack .)* RCurBrack)
	Dot			<- '.' Sp
	DotDot 		<- '..' Sp
	Eq 			<- '=' Sp
	HeadId 		<- [a-zA-Z0-9_]
	Id			<- !Reserved [a-zA-Z_][a-zA-Z0-9_]* Sp
	UInt 		<- [0-9]^+1 Sp
	LBrack 		<- '[' Sp
	LCurBrack 	<- '{' Sp
	LPar		<- '(' Sp
	Pointer 	<- '^' Sp
	RBrack 		<- ']' Sp
	RCurBrack 	<- '}' Sp
	RPar		<- ')' Sp
	UReal 		<- [0-9]^+1 ('.' [0-9]^+1 / E ('+'/'-')^-1 [0-9]^+1) Sp
	Semi 		<- ';' Sp
	Sp			<- (%s / %nl / Comments)*
	String		<- "'" [^']* "'" Sp

	Reserved 	<- (
		ARRAY /
		BEGIN /
		CONST /
		DO / DOWNTO /
		ELSE / END /
		FILE / FOR / FUNCTION /
		GOTO /
		IF /
		LABEL /
		NIL /
		OF /
		PACKED / PROCEDURE / PROGRAM /
		REPEAT /
		SET /
		THEN / TO / TYPE /
		UNTIL / 
		VAR /
		WHILE
	)

	ARRAY 			<- A R R A Y 				!HeadId Sp
	BEGIN 			<- B E G I N 				!HeadId Sp
	CONST 			<- C O N S T 				!HeadId Sp
	DO 				<- D O 						!HeadId Sp
	DOWNTO 			<- D O W N T O 				!HeadId Sp
	ELSE			<- E L S E 					!HeadId Sp
	END				<- E N D 					!HeadId Sp
	FILE 			<- F I L E 					!HeadId Sp
	FOR 			<- F O R 					!HeadId Sp
	FUNCTION 		<- F U N C T I O N 			!HeadId Sp
	GOTO 			<- G O T O 					!HeadId Sp
	IF 				<- I F 						!HeadId Sp
	LABEL 			<- L A B E L 				!HeadId Sp
	NIL 			<- N I L 					!HeadId Sp
	OF 				<- O F 						!HeadId	Sp
	PACKED 			<- P A C K E D 				!HeadId Sp
	PROCEDURE 		<- P R O C E D U R E 		!HeadId Sp
	PROGRAM 		<- P R O G R A M 			!HeadId Sp
	RECORD 			<- R E C O R D 				!HeadId Sp
	REPEAT 			<- R E P E A T 				!HeadId Sp
	SET 			<- S E T 					!HeadId Sp
	THEN 			<- T H E N 					!HeadId Sp
	TO 				<- T O 						!HeadId Sp
	TYPE 			<- T Y P E 					!HeadId Sp
	UNTIL 			<- U N T I L 				!HeadId Sp
	VAR 			<- V A R 					!HeadId Sp
	WHILE 			<- W H I L E 				!HeadId Sp

	A			<- 'a' / 'A'
	B			<- 'b' / 'B'
	C			<- 'c' / 'C'
	D			<- 'd' / 'D'
	E			<- 'e' / 'E'
	F			<- 'f' / 'F'
	G			<- 'g' / 'G'
	H			<- 'h' / 'H'
	I			<- 'i' / 'I'
	J			<- 'j' / 'J'
	K			<- 'k' / 'K'
	L			<- 'l' / 'L'
	M			<- 'm' / 'M'
	N			<- 'n' / 'N'
	O			<- 'o' / 'O'
	P			<- 'p' / 'P'
	Q			<- 'q' / 'Q'
	R			<- 'r' / 'R'
	S			<- 's' / 'S'
	T			<- 't' / 'T'
	U			<- 'u' / 'U'
	V			<- 'v' / 'V'
	W			<- 'w' / 'W'
	X			<- 'x' / 'X'
	Y			<- 'y' / 'Y'
	Z			<- 'z' / 'Z'
]])


local Parser = {};

Parser.parse = function(input)
	local ast, err, err_pos = g:match(input)

	if not ast then
		local row, col = re.calcline(input,err_pos)
		err_pos = {row=row, col=col}
	end

	return ast, err, err_pos
end

return Parser