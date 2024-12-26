function Fill2Curves(t,x,y,clr1,clr2)
% Fill Color between 2 Curves
%   t: row index
%   x1: row vector
%   x2: row vector
%   clr1: color for x>=y
%   clr2: color for x< y

stem(t, max([x; y]),'--k','LineWidth',.5)
hold on
for k = 1:length(t)-1
    if and(x(k)-y(k) >= 0, x(k+1)-y(k+1) >= 0)
        idx = [k k+1];
        fill([t(idx),fliplr(t(idx))], [x(idx),fliplr(y(idx))], clr1,...
            'EdgeColor','none','FaceAlpha',0.25)
    end
    if and(x(k)-y(k) <= 0, x(k+1)-y(k+1) <= 0)
        idx = [k k+1];
        fill([t(idx),fliplr(t(idx))], [x(idx),fliplr(y(idx))], clr2,...
            'EdgeColor','none','FaceAlpha',0.25)
    end
    if and(x(k)-y(k) > 0, x(k+1)-y(k+1) < 0)
        inter_t = k + (x(k)-y(k))/((x(k)-y(k))-(x(k+1)-y(k+1)));
        inter_xy = x(k) + (x(k+1)-x(k))*(x(k)-y(k))/((x(k)-y(k))-(x(k+1)-y(k+1)));
        fill([[k inter_t],fliplr([k inter_t]) ],     [[x(k) inter_xy],fliplr([y(k) inter_xy]) ],     clr1,...
            'EdgeColor','none','FaceAlpha',0.25)
        fill([[inter_t k+1],fliplr([inter_t k+1]) ], [[inter_xy x(k+1)],fliplr([inter_xy y(k+1)]) ], clr2,...
            'EdgeColor','none','FaceAlpha',0.25)
    end
    if and(x(k)-y(k) < 0, x(k+1)-y(k+1) > 0)
        inter_t = k + (x(k)-y(k))/((x(k)-y(k))-(x(k+1)-y(k+1)));
        inter_xy = x(k) + (x(k+1)-x(k))*(x(k)-y(k))/((x(k)-y(k))-(x(k+1)-y(k+1)));
        fill([[k inter_t],fliplr([k inter_t]) ],     [[x(k) inter_xy],fliplr([y(k) inter_xy]) ],     clr2,...
            'EdgeColor','none','FaceAlpha',0.25)
        fill([[inter_t k+1],fliplr([inter_t k+1]) ], [[inter_xy x(k+1)],fliplr([inter_xy y(k+1)]) ], clr1,...
            'EdgeColor','none','FaceAlpha',0.25)
    end
end
hold off

end