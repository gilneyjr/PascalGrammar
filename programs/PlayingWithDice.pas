(*378A - Playing with Dice: Codeforces.com*)
program PlayingWithDice;

function abs(x: integer): integer;
begin
	if x < 0 then
		abs := -x
	else
		abs := x;
end;

var
	i, a, b : integer;
	draw, a_win, b_win : integer;
begin
	readln(a,b);
	draw := 0;
	a_win := 0;
	b_win := 0;
	for i := 1 to 6 do
	begin
		if abs(i-a) < abs(i-b) then
			a_win := a_win+1
		else
			if abs(i-a) = abs(i-b) then
				draw := draw+1
			else
				b_win := b_win+1;
	end;
	writeln(a_win, ' ', draw, ' ', b_win);
end.