% ランダムな楕円データを使って補正行列の動作確認

clear variables;
close all;
clc;

div_t = 36;
div = 9;

if mod(div_t, div) == 0
    for i = 1 : 1
        [in_a, in_b, in_phase, in_xo, in_yo] = GenerateRandomEllipse(1, 10, -5, 5);        
        in_phase_deg = in_phase * 180 / pi;
        
        % サンプリング点
        t = 0 : 2 * pi / div_t : 2 * pi;
        [x, y] = Ellipse(in_a, in_b, in_phase, in_xo, in_yo, t);
        plot_raw = plot(x, y, 'r*', 'DisplayName', 'Raw');

        % 標準系係数換算
        [A, B, C, D, E, F] = Ellipse2QuadraticForm(in_a, in_b, in_phase, in_xo, in_yo);

        % 陰関数表示
        hold on;
        plot_base = fimplicit(@(x,y) A.*x.^2 + 2.*B.*x.*y + C.*y.^2 + 2.*D.*x + 2.*E.*y + F, 'b', 'DisplayName', 'Base ellipse');
        hold off;

        % 関数に渡して楕円補正行列を計算
        [S, H, r_a, r_b, r_phase, r_xo, r_yo] = EllipseCorrection(A, B, C, D, E, F);

        r_phase_deg = r_phase / pi * 180;

        % 結果に基づいてサンプリング点作成
        [x, y] = Ellipse(r_a, r_b, r_phase, r_xo, r_yo, t);   
        data = [x; y];
        
        % 補正行列によりサンプリング点を補正
        res_data = zeros(size(data));
        for j = 1 : size(res_data(1, :), 2)
            res_data(:, j) = S * (data(:, j) + H);
        end

        hold on;
        plot_cor = plot(res_data(1, :), res_data(2, :), 'b+', 'DisplayName', 'Corrected');
        arrow_x = zeros(div);
        arrow_y = zeros(div);
        arrow_u = zeros(div);
        arrow_v = zeros(div);
        for j = 1 : div
            jj = j * div_t / div;
            arrow_x(j) = data(1, jj);
            arrow_y(j) = data(2, jj);
            arrow_u(j) = res_data(1, jj) - data(1, jj);
            arrow_v(j) = res_data(2, jj) - data(2, jj);
        end
        quiver(arrow_x, arrow_y, arrow_u, arrow_v, 0);
        hold off;
        
        legend(gca, 'show', 'Location', 'best');
        legend([plot_raw, plot_cor, plot_base]);
        
        % 指示楕円と計算楕円が一致しているかの確認
        if abs(in_a - r_a) > 0.01
            fprintf('a-> input:%f  result:%f\n', in_a, r_a);
        end
        if abs(in_b - r_b) > 0.01
            fprintf('b-> input:%f  result:%f\n', in_b, r_b);
        end
        if abs(in_phase_deg - r_phase_deg) > 0.01
            fprintf('theta-> input:%f  result:%f  A:%f  B:%f  C:%f  D:%f  E:%f  F:%f\n', in_phase_deg, r_phase_deg, A, B, C, D, E, F);
        end
        if abs(in_xo - r_xo) > 0.01
            fprintf('xo-> input:%f  result:%f\n', in_xo, r_xo);
        end
        if abs(in_yo - r_yo) > 0.01
            fprintf('xo-> input:%f  result:%f\n', in_yo, r_yo);
        end
    end
    
    SetAspectRatioAsSquare(gcf);
end

clear('ans', 'arrow_u', 'arrow_v', 'arrow_x', 'arrow_y', 'data');
clear('div', 'div_t', 'i', 'j', 'jj');
clear('plot_base', 'plot_cor', 'plot_raw');
clear('in_theta', 'r_theta', 'res_data', 't', 'x', 'y');