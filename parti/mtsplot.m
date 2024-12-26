function f = mtsplot(X,XT,markersize,linewidth)
%mtsplot Multiple Time Series Plot in a parell manner
% X  is a cell with 1 row with data structure 
%    {[t1 X_n\times(p-1)], [t2 X_n\times(p-1)], ...}
% XT is the cubic splines with the same tructure as X.

    p = size(X{1},2);
    
    f = figure;
    clr = {'','r','g','b','m','c','k'};
    fig = cell(1,p);
    for i=1:size(X,2)
        % plot each section/profile
        for j=2:p                       % the 1st column is time index
            plot3(i*ones(size(X{i}(:,1))), ...
                X{i}(:,1), X{i}(:,j),'.','Color',clr{j},'MarkerSize',markersize)
            if and(i==1,j==2)
                hold on
            end
            fig{j} = plot3(i*ones(size(XT{i}(:,1))), ...
                XT{i}(:,1), XT{i}(:,j),'-','Color',clr{j},'LineWidth',linewidth);
        end
    end
    hold off
    
    grid on
    % xlabel('$\iota$','Interpreter','latex')
    % ylabel('$t$','Interpreter','latex')
    % zlabel('$x_\iota^{(p)}(t)$','Interpreter','latex')

    % ylabel('Time')
    % xlabel('City')
    zlabel('Concentration')

    
    % lgd = cell(1,p);
    % for j=2:p
    %     lgd{j} = ['$x_\iota^{(',num2str(j-1),')}(t)$'];
    % end
    lgd = {'','PM2.5','PM10','NO2','SO2','CO','O3'};
    legend([fig{2:end}], lgd{2:end},...
        'Interpreter','latex','Location','north','Orientation','horizontal')

end




