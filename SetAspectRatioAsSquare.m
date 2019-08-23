function diffY = SetAspectRatioAsSquare(fig)
%SetAspectRatioAsSquare Figureハンドルの指定先のグリッドが正方形になるように調整する
%   input  : 操作対象のFigureオブジェクトfig
%   outpus : ウィンドウサイズの変更量
    figure(fig);
    hs = findall(gcf, 'Type', 'Axes');
    ax = hs(1, 1);

    % Figureウィンドウサイズの変更
    lX = abs(ax.XLim(1, 1) - ax.XLim(1, 2));
    lY = abs(ax.YLim(1, 1) - ax.YLim(1, 2));
    pos = fig.Position;
    ypx = lY / lX; 
    diffY = pos(3)*ypx - pos(4);
    fig.Position = [pos(1) pos(2)-diffY pos(3) pos(3)*ypx];
    ax.Position = [0.1, 0.1, 0.8, 0.8];
    % 軸目盛刻みの変更
    ax.XGrid = 'on';
    ax.YGrid = 'on';
    xTick = ax.XTick(2) - ax.XTick(1);
    yTick = ax.YTick(2) - ax.YTick(1);
    if xTick > yTick
        newYLimMin = 0;
        while newYLimMin > ax.YLim(1, 1)
            newYLimMin = newYLimMin - xTick;
        end
        newYLimMax = newYLimMin;
        while newYLimMax < ax.YLim(1, 2)
            newYLimMax = newYLimMax + xTick;
        end
        ax.YLim = [newYLimMin newYLimMax];
        ax.YTick = newYLimMin : xTick : newYLimMax;
    else
        newXLimMin = 0;
        while newXLimMin > ax.XLim(1, 1)
            newXLimMin = newXLimMin - yTick;
        end
        newXLimMax = newXLimMin;
        while newXLimMax < ax.XLim(1, 2)
            newXLimMax = newXLimMax + yTick;
        end
        ax.XLim = [newXLimMin newXLimMax];
        ax.XTick = newXLimMin : yTick : newXLimMax;
    end
end

