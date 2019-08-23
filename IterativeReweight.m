function theta = IterativeReweight (xi, threshold, covFunc)
    % IterativeReweight 2次形式で与えられる重み反復法の計算
    % (xi(x,y), theta) = 0
    % のxiを引数とし幾何学推定解thetaを返す
    % 推定変数の数m，データ長nとして
    % xiはm行n列，thetaは長さmの縦ベクトル
    % thresholdはtheta≒theta_oと判断する閾値
    
    m = size(xi, 1);
    N = size(xi, 2);
    theta_o = zeros(m, 1);
    theta = ones(m, 1);
    Wa = ones(1, N);
    while true
        sm =  zeros(m, m);
        for alpha = 1 : N
            sm = sm + Wa(1, alpha) * xi(:, alpha) * transpose(xi(:, alpha));
        end
        M = (1 / N) .* sm;
        [eV, eD] = eig(M);
        [d,ind] = sort(diag(eD));
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
        for alpha = 1 : N
            Wa(1, alpha) = 1 / (theta' * covFunc(xi(:, alpha)) * theta);
        end
    end
end