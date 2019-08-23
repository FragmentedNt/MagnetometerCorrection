function [ S, H, a, b, phase, xo, yo, n ] = EllipseCorrection ( A, B, C, D, E, F )
%EC 2次形式で与えられる楕円のパラメータ及びそれの補正行列を計算
%   input  : 2次形式 Ax^2 + 2Bxy + Cy^2 + 2Dx + 2Ey + F = 0の各係数
%   output : 補正行列S, H, 楕円パラメータ長軸a，短軸b，長軸の傾きtheta，中心（xo, yo)

AA = [A B; B C];

% オフセット計算
res = AA \ [-D; -E];
xo = res(1,1);
yo = res(2,1);

% 陰関数の定数倍係数計算
n = -1 / (A*xo^2+2*B*xo*yo+C*yo^2+2*D*xo+2*E*yo+F);
A = n*A;
B = n*B;
C = n*C;
D = n*D;
E = n*E;
F = n*F;

% 傾き計算
if eq(A, C)
    phase = pi / 4;
else
    phase = 1/2*atan(2*B/(A-C));
end

% 軸長さ計算
a = sqrt(abs(cos(2*phase) / (A*cos(phase)^2 - C*sin(phase)^2)));
b = sqrt(abs(cos(2*phase) / (C*cos(phase)^2 - A*sin(phase)^2)));

% 長短補正
if a < b
    swap = a;
    a = b;
    b = swap;
    if phase > 0
        phase = phase - 0.5*pi;
    else
        phase = phase + 0.5*pi;
    end
end


% % 固有ベクトルから軸長さを求める -> 傾きが近傍軸の角度を指すため補正方法がわからなかった
% AA = n .* AA;

% % 固有ベクトル出力
% [eV, eD] = eig(AA);
% [d,ind] = sort(diag(eD));
% eD = eD(ind, ind);
% eV = eV(:, ind);
% e11 = eV(1, 1);
% e12 = eV(1, 2);
% e21 = eV(2, 1);
% e22 = eV(2, 2);

% % 長軸/短軸計算
% a = sqrt(abs(1 / (A*e11^2 + 2*B*e11*e21 + C*e21^2)));
% b = sqrt(abs(1 / (A*e12^2 + 2*B*e12*e22 + C*e22^2)));


scale = a / b;
S = [cos(phase) sin(phase); -sin(phase)*scale cos(phase)*scale];
S = [cos(phase) -sin(phase); sin(phase) cos(phase)] * S;  % 傾きに基づいて長軸がx軸に一致するよう回転させてしまうので逆回転操作を行う
H = [-xo; -yo];

end