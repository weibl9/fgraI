clc
clear
close all

addpath('parti\')

%% Data 
load("PartI-mts-data.mat")
X = X';
objnames = {'Anqing', 'Bozhou', 'Changzhou', 'Chuzhou', 'Hangzhou', ...
            'Hefei', 'Huangshan','Huzhou', 'Jiaxing', 'Jinhua',	'Lishui',...
        	'Ma''anshan', 'Nanjing', 'Nantong', 'Ningbo', 'Shanghai', 'Shaoxing',...
            'Suzhou', 'Taizhou-JS', 'Taizhou-ZJ', 'Tongling', 'Wenzhou', 'Wuhu',...
             'Wuxi', 'Xuancheng', 'Yangzhou', 'Zhenjiang', 'Zhoushan'   };
ns = length(X);          % number of objects/sections
nt = size(X{1},1);       % length of time series

%% Cubic spline based intrinsic functions
if true
    p = size(X{1},2);
    nT = 100;                           % resolution of grids
    XT = cell(size(X));
    for i=1:ns
        Tspan = linspace(X{i}(1,1),X{i}(end,1),nT);
        XT{i}(:,1) = Tspan;
        for j=2:p                       % the 1st column is time index
            XT{i}(:,j) = spline(X{i}(:,1),X{i}(:,j),Tspan);
        end
    end
    
    f1 = mtsplot(X,XT, 15, 1);          % markersize & linewidth
    view(-2, 48.6)
    xlim([1 28]) 
    xticks([1:28])    
    xticklabels(objnames)
    set(gca,"FontSize",13)
    set(f1,'position',[10 200 1750 580])
    exportgraphics(f1,'..\TeX-amm\Figure-I-11.png','Resolution',600)
end

%%
varnames = {"","PM2.5","PM10","NO2","SO2","CO","O3"};

for flag = 1:4
switch flag
    case 1 % PM 2.5 
        idx = [1 2];
        gro = 0;
    case 2 % PM 10
        idx = [1 3];
        gro = 0;
    case 3 % PM 2.5 & PM 10
        idx = [1 2 3];
        gro = 0;
    case 4 % 4 of pollutants
        idx = [1:7];
        gro = 2;
end

ord = 0; 

ns = length(X);          % number of objects/sections
pfd = zeros(ns,ns);
for i=1:ns
    for j=1:ns
        if i>j      % if validate accuracy, set i>=j 
            pfd(i,j) = fdist4mts(X{i}(:,idx),X{j}(:,idx),ord,gro);
        end
    end
end

% Pairwise Functional Relational Degrees between objects
clus.pfd = transpose(pfd(pfd~=0));               % mtrix: squareform()
zeta = log(9)/(max(clus.pfd)-min(clus.pfd) );       % scale: max/min = 9
clus.pfg = 1-exp(-zeta*clus.pfd); 

% Hierarchical cluster tree
figure
clus.tree = linkage(clus.pfg,'average');        % 'average' linkage
clus.dend = dendrogram(clus.tree,'ColorThreshold','default','Orientation','top', 'Labels',objnames');
clus.labs = cluster(clus.tree,'maxclust',3);      %  specify number of clusters

% Figure
set(clus.dend,'LineWidth',2)
ylabel('$1-g_{i,j}$','Interpreter','latex')
set(gca,"FontSize",13)
set(gcf,'position',[510 50 750 350])
exportgraphics(gcf,['..\TeX-amm\Figure-I-12_',char(strcat(varnames{idx(2:end)})),'.png'],'Resolution',600)

% Clusters
disp('Cluster assignments:');
disp(table(objnames', clus.labs));

end















