function theta = LeastSquares(xi)
    % Renormalization 2次形式で与えられる最小二乗法の計算
    % (xi(x,y), theta) = 0
    % のxiを引数とし幾何学推定解thetaを返す
    % 推定変数の数m，データ長nとして
    % xiはm行n列，thetaは長さmの縦ベクトル
    
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

