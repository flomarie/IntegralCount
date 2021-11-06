uses ptcGraph, ptcCrt, functions;

type
    func_t = function (x : real) : real;

const AX = -5;
      BX = 5;
      AY = -20;
      BY = 20;
      intr_a = -2;
      intr_b = -1;
      INF = 10000000;
      YEL = Yellow;
      SPL_X = 10;
      SPL_Y = 40;
      WIDTH = 5;

var
    intr1, intr2, intr3, intr_debug : real;
    I1, I2, I3, I, I_debug : real;
    eps_root, eps_integral : real;
    n0, debug, graph : longint;
    col, delta_col : word;
    t, max_f : real;
    gd, gm, pr1, pr2 : integer;
    size_x, size_y : integer;
    
{F+}
{Поиск точки пересечения}
function intersection(f, g, fd1, gd1, fd2, gd2 : func_t; a, b, EPS : real): real;
var c : real;
begin
    writeln('Intermediate values in form left_bound, right_bound, function value at root');
    while (abs(b - a) > EPS) do
    begin
        c := (a + b) / 2;
        writeln(a:3:pr1, ' ', b:3:pr1, ' ', (f(c) - g(c)):3:pr1);
        if ((fd1(c) - gd1(c)) * (fd2(c) - gd2(c)) > 0) then
        begin
            c := (a * (f(b) - g(b)) - b * (f(a) - g(a))) / ((f(b) - g(b)) - (f(a) - g(a)));
            a := c;
            c := b - (f(b) - g(b)) / (fd1(b) - gd1(b));
            b := c;
        end
        else
        begin
            c := (a * (f(b) - g(b)) - b * (f(a) - g(a))) / ((f(b) - g(b)) - (f(a) - g(a)));
            b := c;
            c := a - (f(a) - g(a)) / (fd1(a) - gd1(a));
            a := c;
        end;
    end;
    c := (a + b) / 2;
    intersection := (a + b) / 2;
end;

{Подсчет интеграла}
function integral(f : func_t; a, b, EPS : real; n0 : longint) : real;
var n, j: longint;
    h, I, I1: real;
begin
    n := n0;
    I := INF;
    I1 := 0;
    Writeln('Integral, difference between integral and previos integral, number of split points');
    while ((abs(I - I1) / 3) > EPS) do
    begin
        I1 := I;
        I := 0;
        h := (b - a) / n;
        for j := 0 to n - 1 do
        begin
            I := I + f(a + (j + 0.5) * h);
        end;
        I := I * h;
        writeln(I:3:pr2, ' ', (I - I1):3:pr2, ' ', n);
        n := 2 * n;
    end;
    integral := I;
end;

{Отображение точки на оси ОХ графика в значение функции в этой точке}
function point_graph(f : func_t; x : real) : integer;
begin
    point_graph := trunc(((-f(AX + x / size_x * (BX - AX))) - AY) / (BY - AY) * size_y);
end;

{Рисование системы координат}
procedure draw_field();
var i : integer;
begin
    detectgraph(gd, gm);
    InitGraph(gd, gm, '');
    size_x := GetMaxX;
    size_y := GetMaxY;
    col := GetMaxColor;
    delta_col := col div 4;
    SetColor(col);
    line(0, size_y div 2, size_x, size_y div 2);
    line (size_x div 2, 0, size_x div 2, size_y);
    for i := 0 to SPL_X do
    begin
        line(i * size_x div SPL_X, size_y div 2 - WIDTH, i * size_x div SPL_X, size_y div 2 + WIDTH);
    end;
    for i := 0 to SPL_Y do
    begin
        line(size_x div 2 - WIDTH, i * size_y div SPL_Y, size_x div 2 + WIDTH, i * size_y div SPL_Y);
    end;
end;

{Рисование графика}
procedure draw_graph(f : func_t; col : word);
var x : integer;
begin
    SetColor(col);
    MoveTo(0, point_graph(f, 0));
    for x := 1 to size_x do
    begin
        if (x <> round(size_x / (BX - AX) * 3)) then
            LineTo(x, point_graph(f, x))
        else
            MoveTo(x, point_graph(f, x + 1));
    end;
end;

{Закрашивание области}
procedure fill_area();
begin
    SetFillStyle(2, YEL);
    FloodFill(round(size_x / (BX - AX) * 3.5),
                    point_graph(@f1, round(size_x / (BX - AX) * 3.5)) + 5, YEL);
end;

{Отображение точки функции в точку на графике}
function func_to_graph(x : real) : integer;
begin
    func_to_graph := trunc((x - AX) / (BX - AX) * size_x);
end;

{Подписи для графика}
procedure draw_labels();
var t : string;
begin
    SetColor(col);
    OutTextXY(size_x div SPL_X * (SPL_X div 2 + 1), size_y div 2 - 20, '1');
    OutTextXY(size_x div 2 - 10, size_y div SPL_Y * (SPL_Y div 2 - 1), '1');
    SetColor(col);
    SetLineStyle(1, 1, 1);
    Line(func_to_graph(intr1), point_graph(@f1, func_to_graph(intr1)), func_to_graph(intr1), size_y div 2);
    Str(intr1:3:pr1, t);
    OutTextXY(func_to_graph(intr1), size_y div 2 + 10, t);
    Line(func_to_graph(intr2), point_graph(@f2, func_to_graph(intr2)), func_to_graph(intr2), size_y div 2);
    Str(intr2:3:pr1, t);
    OutTextXY(func_to_graph(intr2), size_y div 2 + 20, t);
    Line(func_to_graph(intr3), point_graph(@f2, func_to_graph(intr3)), func_to_graph(intr3), size_y div 2);
    Str(intr3:3:pr1, t);
    OutTextXY(func_to_graph(intr3), size_y div 2 + 10, t);
    Str(I:3:pr2, t);
    t := 'S = ' + t;
    OutTextXY(func_to_graph(-1), size_y div 3, t);
end;

{Поиск максимума}
function max(a, b : real) : real;
begin
    if (a < b) then
        max := b
    else
        max := a;
end;

{Подсчет знаков для точности}
function count_precision(eps : real) : integer;
var a : real;
	n : integer;
begin
	a := 0.1;
	n := 1;
	while (a > eps) do
	begin
		inc(n);
		a := 0.1 * a;
	end;
	count_precision := n;
end;

begin
    Writeln('Enable debug mode?(0 - no, 1 - yes)');
    Readln(debug);
    if (debug = 0) then
    begin
        Writeln('Enter the precision for root calculation');
        Readln(eps_root);
        pr1 := count_precision(eps_root);
        Writeln('Enter the precision for integral calculation');
        Readln(eps_integral);
        pr2 := count_precision(eps_integral);
        Writeln('Enter the initial number of split points');
        Readln(n0);
        Writeln('Show graph? (0 - no, 1 - yes)');
        Readln(graph);
        Writeln('Intersection of f1 and f3');
        intr1 := intersection(@f1, @f3, @f1d1, @f3d1, @f1d2, @f3d2, intr_a, intr_b, eps_root);
        Writeln('Intersection of f2 and f3');
        intr2 := intersection(@f2, @f3, @f2d1, @f3d1, @f2d2, @f3d2, intr_a, intr_b, eps_root);
        Writeln('Intersection of f1 and f2');
        intr3 := intersection(@f1, @f2, @f1d1, @f2d1, @f1d2, @f2d2, intr_a, intr_b, eps_root);
        Writeln('Integral of f1');
        I1 := integral(@f1, intr1, intr3, eps_integral, n0);
        Writeln('Integral of f3');
        I2 := integral(@f3, intr1, intr2, eps_integral, n0);
        Writeln('Integral of f2');
        I3 := integral(@f2, intr2, intr3, eps_integral, n0);
        Writeln('Intersection points:');
        Writeln(intr1:2:pr1, ' ', f1(intr1):2:pr1);
        Writeln(intr2:2:pr1, ' ', f3(intr2):2:pr1);
        Writeln(intr3:2:pr1, ' ', f2(intr3):2:pr1);
        t := (intr_a + intr_b) / 2;
        max_f := max(f1(t), max(f2(t), f3(t)));
        if (max_f = f1(t)) then
            I := I1 - I2 - I3
        else if (max_f =  f2(t)) then
            I := I3 - I1 - I2
        else
            I := I2 - I1 - I3;
        Writeln('Square = ', I:3:pr2);
        if (graph = 1) then
        begin
            draw_field;
            draw_graph(@f1, YEL);
            draw_graph(@f2, YEL);
            draw_graph(@f3, YEL);
            fill_area;
            draw_graph(@f1, col - delta_col);
            draw_graph(@f2, col - 2 * delta_col);
            draw_graph(@f3, col - 3 * delta_col);
            draw_labels;
            readln;
            closegraph;
        end;
    end
    else
    begin
        Writeln('Function for root debug: y1 = x^2, y2 = 1 on seg. [0, 5], EPS = 0.001');
        pr1 := count_precision(0.001);
        intr_debug := intersection(@root_debug1, @root_debug2, @root_debug1d1,
                                   @root_debug2d1, @root_debug1d2, @root_debug2d2, 0, 5, 0.001);
        Writeln('x = ', intr_debug:3:pr1);
        Writeln('Function for integral debug: y = x on seg. [0, 4], EPS = 0.001, n0 = 2');
        pr2 := count_precision(0.001);
        I_debug := integral(@integral_debug, 0, 4, 0.001, 2);
        Writeln('Integral = ', I_debug:3:pr2);
    end;
end.

