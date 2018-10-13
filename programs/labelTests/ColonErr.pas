program ColonErr;

type
	a = record
			case id of
				1, 2 ( id : int );
				2, 3 : (oi int);
		end;

function f (a, b : real; c, d int) int;
begin
	{ Nothing }
end;

begin
	1 : write('ola');
	2 a := 3
end.