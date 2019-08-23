function theta = Renormalization (xi, threshold, covFunc)
    % Renormalization 2次形式で与えられるくりこみ法の計算
    % (xi(x,y), theta) = 0
    % のxiを引数とし幾何学推定解thetaを返す
    % 推定変数の数m，データ長nとして
    % xiはm行n列，thetaは長さmの縦ベクトル
    % thresholdはtheta≒theta_oと判断する閾値
        
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