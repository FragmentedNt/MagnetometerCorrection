function [ x, y ] = Ellipse( a, b, phase, xo, yo, t, variance_x, variance_y )
%Ellipse 楕円上の点を媒介変数tに基づいて作成
%   長軸a短軸b傾きtheta中心[xo yo]の楕円上の点を媒介変数tに基づいて作成
%   input  : a, b, theta, xo, yo - スカラ, t - ベクトル
%   output : 媒介変数tに対応するプロット点x,y

if exist('variance_x', 'var') && exist('variance_y', 'var')
    R = chol([variance_x 0; 0 variance_y]);
    z = R * randn(2, size(t, 2));
else
    z = zeros(2, size(t, 2));
end

x_ = a * cos(t);
y_ = b * sin(t);
x = x_.*cos(phase) - y_.*sin(phase) + xo + z(1, :);
y = x_.*sin(phase) + y_.*cos(phase) + yo + z(2, :);

end

