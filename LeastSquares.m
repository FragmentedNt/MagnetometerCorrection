function theta = LeastSquares(xi)
    % Renormalization 2���`���ŗ^������ŏ����@�̌v�Z
    % (xi(x,y), theta) = 0
    % ��xi�������Ƃ��􉽊w�����theta��Ԃ�
    % ����ϐ��̐�m�C�f�[�^��n�Ƃ���
    % xi��m�sn��Ctheta�͒���m�̏c�x�N�g��
    
    m = size(xi, 1);
    n = size(xi, 2);
    Mls = zeros(m, m);
    for alpha = 1:n
        Mls = Mls + (xi(:, alpha) * transpose(xi(:, alpha)));
    end
    Mls = (1 / n) .* Mls;
    [eV, eD] = eig(Mls);
    [d,ind] = sort(diag(eD));
    eD = eD(ind, ind);
    eV = eV(:, ind);
    theta = eV(:, 1);
end

