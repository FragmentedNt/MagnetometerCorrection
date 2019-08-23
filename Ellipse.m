function [ x, y ] = Ellipse( a, b, phase, xo, yo, t, variance_x, variance_y )
%Ellipse �ȉ~��̓_��}��ϐ�t�Ɋ�Â��č쐬
%   ����a�Z��b�X��theta���S[xo yo]�̑ȉ~��̓_��}��ϐ�t�Ɋ�Â��č쐬
%   input  : a, b, theta, xo, yo - �X�J��, t - �x�N�g��
%   output : �}��ϐ�t�ɑΉ�����v���b�g�_x,y

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

