clc
clear 
close all

addpath("parti\")

%%
X = [0.190 	0.198 	0.218 	0.192 	0.438 	1699.8
     0.224 	0.234 	0.257 	0.226 	0.517 	1699.4
     0.259 	0.269 	0.296 	0.260 	0.598 	1699.1
     0.293 	0.304 	0.336 	0.305 	0.678 	1698.6
     0.341 	0.377 	0.437 	0.403 	1.008 	1696.1
     0.372 	0.409 	0.481 	0.442 	1.094 	1695.3
     0.403 	0.442 	0.526 	0.481 	1.181 	1694.4
     0.433 	0.473 	0.570 	0.521 	1.267 	1693.5
     0.458 	0.550 	0.628 	0.589 	1.345 	1692.8
     0.487 	0.580 	0.673 	0.624 	1.429 	1691.9
     0.516 	0.610 	0.718 	0.661 	1.514 	1690.9
     0.544 	0.638 	0.763 	0.701 	1.600 	1689.9];
t = [1 2 3 4 6 7 8 9 10 11 12 13]';

%% Functional Grey Relational Degrees
gro = 2; 
ord = 1;
fgrds = nan(5,6);
for j=1:5
    for k=1:5
        fgrds(j,k) = fgrd4mts([t X(:,j)],[t X(:,k)],0.1,ord,gro);
    end
    fgrds(j,6) = fgrd4mts([t X(:,j)],[t X(:,6)],0.1,ord,gro);
end

%% Grey Relational Operator
% dX = {  x1   x2   x3   x4   x5   x6;
%        dx1  dx2  dx3  dx4  dx5  dx6;
%       ddx1 ddx2 ddx3 ddx4 ddx5 ddx5};
dX = cell(3,size(X,2));  % Orign Sequences
dY = cell(3,size(X,2));  % Operator Sequences
T = linspace(min(t), max(t), 100)';
for i=1:6
    dX{1,i} = dcs(t,X(:,i),T,0); % alternative: sf = spline(t,xi); dX{1,i} = spline(t,xi,T);
    dX{2,i} = dcs(t,X(:,i),T,1);
    dX{3,i} = dcs(t,X(:,i),T,2);
    switch gro
        case 1    % zero-staring
            dY{1,i} = dX{1,i}-dX{1,i}(1);
            dY{2,i} = dX{2,i}-dX{2,i}(1);
            dY{3,i} = dX{3,i}-dX{3,i}(1);
        case 2    % initialing & initial zero-starting
            dY{1,i} = dX{1,i}./dX{1,i}(1);
            dY{2,i} = dX{2,i}./dX{2,i}(1);
            dY{3,i} = dX{3,i}./dX{3,i}(1);
        otherwise % identical 
            dY{1,i} = dX{1,i};
            dY{2,i} = dX{2,i};
            dY{3,i} = dX{3,i};
    end
end

%% Figure
figure
colororder({'b','r'})
tiledlayout(2,3)

labs_left = {'$x_1(t)$','$x_2(t)$','$x_3(t)$', ...
             '$x_4(t)$','$x_5(t)$','$u(t)$'};
labs_right = {'$\frac{\mathrm{d}}{\mathrm{d}t} x_1(t)$',...
              '$\frac{\mathrm{d}}{\mathrm{d}t} x_2(t)$',...
              '$\frac{\mathrm{d}}{\mathrm{d}t} x_3(t)$',...
              '$\frac{\mathrm{d}}{\mathrm{d}t} x_4(t)$',...
              '$\frac{\mathrm{d}}{\mathrm{d}t} x_5(t)$',...
              '$\frac{\mathrm{d}}{\mathrm{d}t} u(t)$'};

for j=1:6
    if j<6
        nexttile
        yyaxis left
        plot(t, X(:,j),'s','LineWidth',1,'MarkerSize',6); hold on
        plot(T,dX{1,j},'-','LineWidth',1); hold off
        ylabel(labs_left(j),'Interpreter','latex')
    
        yyaxis right
        plot(T,dX{2,j},'-.','LineWidth',1)
        ytickformat('%,.3f')
        ylabel(labs_right(j),'Interpreter','latex')
    
        xlabel('$t$','Interpreter','latex')
        xlim([t(1)-1 t(end)+1]); grid minor
        set(gca,'FontSize',13)
    else 
        nexttile
        yyaxis left
        plot(t, X(:,j),'sk','LineWidth',1,'MarkerSize',6); hold on
        plot(T,dX{1,j},'-k','LineWidth',1); hold off
        ylabel(labs_left(j),'Interpreter','latex')
        set(gca,"YColor",'k')
        
        yyaxis right
        plot(T,dX{2,j},'-g','LineWidth',1)        
        ytickformat('%,.3f')
        ylabel(labs_right(j),'Interpreter','latex')
        set(gca,"YColor",'g')

        xlabel('$t$','Interpreter','latex')
        xlim([t(1)-1 t(end)+1]); grid minor
        set(gca,'FontSize',13) 
    end
end

set(gcf,'position',[200 200 1200 550])
%exportgraphics(gcf,'..\TeX-amm\Figure-I-9.png','ContentType','image','Resolution',600)

%% Figure 
figure
tiledlayout(1,5)

labs_right = {'$\frac{\mathrm{d}}{\mathrm{d}t} v(t)$',...
              '$\frac{\mathrm{d}}{\mathrm{d}t} y_1(t)$',...
              '$\frac{\mathrm{d}}{\mathrm{d}t} y_2(t)$',...
              '$\frac{\mathrm{d}}{\mathrm{d}t} y_3(t)$',...
              '$\frac{\mathrm{d}}{\mathrm{d}t} y_4(t)$',...
              '$\frac{\mathrm{d}}{\mathrm{d}t} y_5(t)$'};

nexttile([1 3])
    plot(T,dY{2,6}./dY{2,6}(1), '-k','LineWidth',1.5)
    hold on 
    plot(T,dY{2,1}./dY{2,1}(1), '--c','LineWidth',1.5)    
    plot(T,dY{2,2}./dY{2,2}(1), '-.m','LineWidth',1.5)
    plot(T,dY{2,3}./dY{2,3}(1), '-.g','LineWidth',1.5)
    plot(T,dY{2,4}./dY{2,4}(1), '-.b','LineWidth',1.5)
    plot(T,dY{2,5}./dY{2,5}(1), '-.r','LineWidth',1.5)
    hold on
    ytickformat('%,.1f')
    ylabel('$\frac{\mathrm{d}}{\mathrm{d}t} y_{\iota}(t)\mathrm{~or~}\frac{\mathrm{d}}{\mathrm{d}t} v(t)$','Interpreter','latex')
    
    grid on
    xlabel('$t$','Interpreter','latex')
    lgd = legend(labs_right,'Interpreter','latex', ...
        'Location','northwest','FontSize',13,'Orientation','vertical');
    set(gca,'FontSize',13)

nexttile([1 2])
    xvalues = { '$\frac{\mathrm{d}}{\mathrm{d}t} y_1(t)$',...
                '$\frac{\mathrm{d}}{\mathrm{d}t} y_2(t)$',...
                '$\frac{\mathrm{d}}{\mathrm{d}t} y_3(t)$',...
                '$\frac{\mathrm{d}}{\mathrm{d}t} y_4(t)$',...
                '$\frac{\mathrm{d}}{\mathrm{d}t} y_5(t)$',...
                '$\frac{\mathrm{d}}{\mathrm{d}t} v(t)$'};
    yvalues = { '$\frac{\mathrm{d}}{\mathrm{d}t} y_1(t)$',...
                '$\frac{\mathrm{d}}{\mathrm{d}t} y_2(t)$',...
                '$\frac{\mathrm{d}}{\mathrm{d}t} y_3(t)$',...
                '$\frac{\mathrm{d}}{\mathrm{d}t} y_4(t)$',...
                '$\frac{\mathrm{d}}{\mathrm{d}t} y_5(t)$'};
    h = heatmap(xvalues,yvalues,fgrds,'Interpreter','latex');
    h.ColorbarVisible = 'off';
    set(gca,'FontSize',13)

set(gcf,'position',[200 200 1100 360])

%exportgraphics(gcf,'..\TeX-amm\Figure-I-10.png','ContentType','image','Resolution',600)

%%












