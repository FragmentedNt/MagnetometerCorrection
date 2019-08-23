function [a, b, phase, xo, yo] = GenerateRandomEllipse(min_radius, max_radius, min_offset, max_offset)
%GenerateRandomEllipse �w��p�����[�^��p���ă����_���ȑȉ~�p�����[�^���쐬
%   input : ���Z���͈̔�min_radius�`max_radius�C���S�ʒu�imin_offset�`max_offset, min_offset�`max_offset)
%   output : ����a, �Z��b, �X��theta�C���S(xo, yo)
if min_radius <= 0
    min_radius = 1;
end
if max_radius <= 0 || max_radius < min_radius
    max_radius = min_radius;
end
if min_offset > max_offset
    swap = max_offset;
    max_offset = min_offset;
    min_offset = swap;
end

r1 = randi([min_radius*100 max_radius*100], 2, 1) / 100;
r2 = randi([min_offset*100 max_offset*100], 2, 1) / 100;
d = randi([-90 90], 1, 1);

a = abs(r1(1));
b = abs(r1(2));
theta_deg = d; % [deg]
xo = r2(1);
yo = r2(2);

% ���Z�o���f�[�V����
if a < b
    swap = a;
    a = b;
    b = swap;
end

% �P�ʕϊ�
phase = theta_deg * pi / 180;

end

