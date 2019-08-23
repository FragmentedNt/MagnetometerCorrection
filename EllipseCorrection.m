function [ S, H, a, b, phase, xo, yo, n ] = EllipseCorrection ( A, B, C, D, E, F )
%EC 2���`���ŗ^������ȉ~�̃p�����[�^�y�т���̕␳�s����v�Z
%   input  : 2���`�� Ax^2 + 2Bxy + Cy^2 + 2Dx + 2Ey + F = 0�̊e�W��
%   output : �␳�s��S, H, �ȉ~�p�����[�^����a�C�Z��b�C�����̌X��theta�C���S�ixo, yo)

AA = [A B; B C];

% �I�t�Z�b�g�v�Z
res = AA \ [-D; -E];
xo = res(1,1);
yo = res(2,1);

% �A�֐��̒萔�{�W���v�Z
n = -1 / (A*xo^2+2*B*xo*yo+C*yo^2+2*D*xo+2*E*yo+F);
A = n*A;
B = n*B;
C = n*C;
D = n*D;
E = n*E;
F = n*F;

% �X���v�Z
if eq(A, C)
    phase = pi / 4;
else
    phase = 1/2*atan(2*B/(A-C));
end

% �������v�Z
a = sqrt(abs(cos(2*phase) / (A*cos(phase)^2 - C*sin(phase)^2)));
b = sqrt(abs(cos(2*phase) / (C*cos(phase)^2 - A*sin(phase)^2)));

% ���Z�␳
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


% % �ŗL�x�N�g�����玲���������߂� -> �X�����ߖT���̊p�x���w�����ߕ␳���@���킩��Ȃ�����
% AA = n .* AA;

% % �ŗL�x�N�g���o��
% [eV, eD] = eig(AA);
% [d,ind] = sort(diag(eD));
% eD = eD(ind, ind);
% eV = eV(:, ind);
% e11 = eV(1, 1);
% e12 = eV(1, 2);
% e21 = eV(2, 1);
% e22 = eV(2, 2);

% % ����/�Z���v�Z
% a = sqrt(abs(1 / (A*e11^2 + 2*B*e11*e21 + C*e21^2)));
% b = sqrt(abs(1 / (A*e12^2 + 2*B*e12*e22 + C*e22^2)));


scale = a / b;
S = [cos(phase) sin(phase); -sin(phase)*scale cos(phase)*scale];
S = [cos(phase) -sin(phase); sin(phase) cos(phase)] * S;  % �X���Ɋ�Â��Ē�����x���Ɉ�v����悤��]�����Ă��܂��̂ŋt��]������s��
H = [-xo; -yo];

end