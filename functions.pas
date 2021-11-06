unit functions;

interface
	function f1(x : real) : real;
	function f2(x : real) : real;
	function f3(x : real) : real;
	function f1d1(x : real) : real;
	function f2d1(x : real) : real;
	function f3d1(x : real) : real;
	function f1d2(x : real) : real;
	function f2d2(x : real) : real;
	function f3d2(x : real) : real;
	function root_debug1(x : real) : real;
	function root_debug2(x : real) : real;
	function root_debug1d1(x : real) : real;
	function root_debug2d1(x : real) : real;
	function root_debug1d2(x : real) : real;
	function root_debug2d2(x : real) : real;
	function integral_debug(x : real) : real;
	const INF = 10000000;
	
implementation
	{Описание функций}
	function f1(x : real) : real;
	begin
		f1 := 0.35 * x * x - 0.95 * x + 2.7;
	end;

	function f2(x : real) : real;
	begin
		f2 := exp(x * ln(3)) + 1;
	end;

	function f3(x : real) : real;
	begin
		if (x = -2) then
			f3 := INF
		else
			f3 := 1 / (x + 2);
	end;

	{Описание производных}
	function f1d1(x : real) : real;
	begin
		f1d1 := 0.7 * x - 0.95;
	end;

	function f2d1(x : real) : real;
	begin
		f2d1 := exp(x * ln(3)) * ln(3);
	end;

	function f3d1(x : real) : real;
	begin
		if (x = -2) then
			f3d1 := INF
		else
			f3d1 := -1 / ((x + 2) * (x + 2));
	end;

	{Описание вторых производных}
	function f1d2(x : real) : real;
	begin
		f1d2 := 0.7;
	end;

	function f2d2(x : real) : real;
	begin
		f2d2 := exp(x * ln(3)) * ln(3) * ln(3);
	end;

	function f3d2(x : real) : real;
	begin
		f3d2 := 2 / ((2 + x) * (2 + x) * (2 + x));
	end;

	{Функции отладки}
	function root_debug1(x : real) : real;
	begin
		root_debug1 := x * x;
	end;

	function root_debug2(x : real) : real;
	begin
		root_debug2 := 1;
	end;
	{Производные функций отладки}
	function root_debug1d1(x : real) : real;
	begin
		root_debug1d1 := 2 * x;
	end;

	function root_debug2d1(x : real) : real;
	begin
		root_debug2d1 := 0;
	end;
	
	{Вторые производные функций отладки}
	function root_debug1d2(x : real) : real;
	begin
		root_debug1d2 := 2;
	end;

	function root_debug2d2(x : real) : real;
	begin
		root_debug2d2 := 0;
	end;
	
	{Функкция отлдаки интеграла}
	function integral_debug(x : real) : real;
	begin
		integral_debug := x;
	end;
	
begin

end.
