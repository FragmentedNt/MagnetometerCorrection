function theta = Renormalization (xi, threshold, covFunc)
    % Renormalization 2���`���ŗ^�����邭�肱�ݖ@�̌v�Z
    % (xi(x,y), theta) = 0
    % ��xi�������Ƃ��􉽊w�����theta��Ԃ�
    % ����ϐ��̐�m�C�f�[�^��n�Ƃ���
    % xi��m�sn��Ctheta�͒���m�̏c�x�N�g��
    % threshold��theta��theta_o�Ɣ��f����臒l
        
    m = size(xi, 1);
    n = size(xi, 2);
    theta_o = zeros(m, 1);
    theta = ones(m, 1);
    Wa = ones(1, n);
    while true
        smM =  zeros(m, m);
        smN =  zeros(m, m);
        for alpha = 1 : n
            smM = smM + Wa(1, alpha) * xi(:, alpha) * transpose(xi(:, alpha));
            smN = smN + Wa(1, alpha) * covFunc(xi(:, alpha));
        end
        M = (1 / n) .* smM;
        N = (1 / n) .* smN;
        
        
        [eV, eD] = eig(M, N);
        [d,ind] = sort(diag(abs(eD)));
        eD = eD(ind, ind);
        eV = eV(:, ind);
        theta = eV(:, 1);

        isEnd = true;
        for i = 1 : m
            isEnd = isEnd & (abs(abs(theta_o(i)) - abs(theta(i))) < threshold);
        end

        if isEnd
            break
        end

        theta_o = theta;
        for alpha = 1 : n
            Wa(1, alpha) = 1 / (theta' * covFunc(xi(:, alpha)) * theta);
        end
    end
end