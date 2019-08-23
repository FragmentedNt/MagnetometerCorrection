function [ A, B, C, D, E, F ] = Ellipse2QuadraticForm( a, b, phase, xo, yo )
%Ellipse2QuadraticForm �󂯎�����ȉ~�p�����[�^��񎟌`���ɂ��ĕԂ�
%   input  :  
%   output : Ax^2 + 2Bxy + Cy^2 + 2(Dx + Ey) + F = 0�ŕ\�����񎟌`���̊e�W��A�`F
A = cos(phase)^2 / a^2 + sin(phase)^2 / b^2;
B = (1/a^2 - 1/b^2) * cos(phase) * sin(phase);
C = sin(phase)^2 / a^2 + cos(phase)^2 / b^2;
D = -A*xo - B*yo;
E = -B*xo - C*yo;
F = A*xo^2 + 2*B*xo*yo + C*yo^2 - 1;
end

