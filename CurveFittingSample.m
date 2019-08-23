% ランダムな楕円データにノイズを与え，幾何学推定を行い動作確認

clear variables;
close all;
clc;

div_t = 100;
div = 10;

[in_a, in_b, in_phase, in_xo, in_yo] = GenerateRandomEllipse(2, 4, 2, 8);
in_phase_deg = in_phase * 180 / pi;

% 二次形式係数計算
[in_A, in_B, in_C, in_D, in_E, in_F] = Ellipse2QuadraticForm(in_a, in_b, in_phase, in_xo, in_yo);

% 計測データの作成
t = 0 : 2 * pi / div_t : 2 * pi;
[sx, sy] = Ellipse(in_a, in_b, in_phase, in_xo, in_yo, t, in_a/10000, in_b/10000);
plot_raw = plot(sx, sy, 'r*', 'DisplayName', 'Raw');

xi = [sx.^2; 2.*sx.*sy; sy.^2; 2.*sx; 2.*sy; ones(1, size(sx, 2))];

% res = LeastSquares(xi);
res = IterativeReweight(xi, 0.001, @CalculateCovariance);
% res = Renormalization(xi, 0.001, @CalculateCovariance);

A = res(1);
B = res(2);
C = res(3);
D = res(4);
E = res(5);
F = res(6);

hold on;
plot_estimated = fimplicit(@(x,y) A.*x.^2 + 2.*B.*x.*y + C.*y.^2 + 2.*D.*x + 2.*E.*y + F, 'DisplayName', 'Estimated');
hold off;

% 関数に渡して楕円補正行列を計算
[S, H, r_a, r_b, r_phase, r_xo, r_yo] = EllipseCorrection(A, B, C, D, E, F);

r_phase_deg = r_phase / pi * 180;

% fprintf('---  input  ---\n');
% Check(in_a, in_b, in_xo, in_yo, in_A, in_B, in_C, in_D, in_E, in_F);
% 
% fprintf('\n---  output  ---\n');
% Check(r_a, r_b, r_xo, r_yo, A, B, C, D, E, F);


% 補正行列により計測データを補正
data = [sx; sy];
cor_data = zeros(size(data));
for j = 1 : size(cor_data(1, :), 2)
    cor_data(:, j) = S * (data(:, j) + H);
end

hold on;
plot_corrected = plot(cor_data(1, :), cor_data(2, :), 'b+', 'DisplayName', 'Corrected');
arrow_x = zeros(div);
arrow_y = zeros(div);
arrow_u = zeros(div);
arrow_v = zeros(div);
for j = 1 : div
    jj = j * div_t / div;
    arrow_x(j) = data(1, jj);
    arrow_y(j) = data(2, jj);
    arrow_u(j) = cor_data(1, jj) - data(1, jj);
    arrow_v(j) = cor_data(2, jj) - data(2, jj);
end
quiver(arrow_x, arrow_y, arrow_u, arrow_v, 0, 'g');
hold off;

legend(gca, 'show', 'Location', 'best');
legend([plot_raw, plot_estimated, plot_corrected]);

SetAspectRatioAsSquare(gcf);

clear('swap');
clear('theta', 'r_theta', 'res', 'res_sx', 'res_sy', 'xi');
clear('i', 'j', 't', 'r1', 'r2', 'd', 'sx', 'sy', 'X', 'data');

function Check(a, b, xo, yo, A, B, C, D, E, F)
    fprintf('Eq     : %fx^2 + 2*%fxy + %fy^2 + 2*%fx + 2*%fy + %f = 0\n', A, B, C, D, E, F);
    fprintf('scale  : %f\n', a/b);
    fprintf('offset : %f(x+%f)^2 + 2*%f(x+%f)(y+%f) + %f(y+%f)^2 + 2*%f(x+%f) + 2*%f(y+%f) + %f = 0\n',...
                       A,   xo,       B,   xo,   yo,   C,   yo,       D,   xo,     E,   yo,   F);
    fprintf('    => : %fx^2 + 2*%fxy + %fy^2 + 2*%fx + 2*%fy + %f = 0\n'...
                     , A, B, C, (A*xo+B*yo+D), (B*xo+C*yo+E), (A*xo^2+2*B*xo*yo+C*yo^2+2*D*xo+2*E*yo+F));
    n = -1 / (A*xo^2+2*B*xo*yo+C*yo^2+2*D*xo+2*E*yo+F);
    fprintf('n      : %f\n', n);
    fprintf('new Eq : %fx^2 + 2*%fxy + %fy^2 + 2*%fx + 2*%fy + %f = 0\n', n*A, n*B, n*C, n*D, n*E, n*F);
end

function V0 = CalculateCovariance(xi)
    V0 = [4*xi(1) 2*xi(2)         0       2*xi(4) 0       0;
          2*xi(2) 4*(xi(1)+xi(3)) 2*xi(2) 2*xi(5) 2*xi(4) 0;
          0       2*xi(2)         4*xi(3) 0       2*xi(5) 0;
          2*xi(4) 2*xi(5)         0       4       0       0;
          0       2*xi(4)         2*xi(5) 0       4       0;
          0       0               0       0       0       0];
%     V0 = [xi(1) xi(2)         0     xi(4) 0     0;
%           xi(2) (xi(1)+xi(3)) xi(2) xi(5) xi(4) 0;
%           0     xi(2)         xi(3) 0     xi(5) 0;
%           xi(4) xi(5)         0     1     0     0;
%           0     xi(4)         xi(5) 0     1     0;
%           0     0             0     0     0     0];
end