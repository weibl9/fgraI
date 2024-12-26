function fgrd = fgrd4mts(Yi,Yj,gamma,ord,gro)
%fgrd4mts Functional Grey Relational Degree for Multiple Time Series
%   Yi is a matrix [ti Xi1 Xi2 ...]
%   Yj is a matrix [tj Xj1 Xj2 ...]
%   gamma>0 is a distinguishing coefficient
%   ord is the ord-th derivative of Yi and Yj
%   gro is the grey relational operator 

    if all(size(Yi) ~= size(Yj))
        error('Matrix dimensions dismatch!')
    end
    
    p = size(Yi,2);
    if p == 1
        error('Matrix must have a [t x1 ...] structure!')
    end

    nT = 200;         % specifying the length of Time Cross vector
    Tc = linspace(max([Yi(1,1) Yj(1,1)]), min([Yi(end,1) Yj(end,1)]), nT)';
    
    dist = zeros(1,p-1);

    for s=2:p
        yTi = dcs(Yi(:,1),Yi(:,s),Tc,ord);       % derivative cubic spline
        yTj = dcs(Yj(:,1),Yj(:,s),Tc,ord);       % derivative cubic spline
        switch gro
            case 1    % zero-staring
                yTij = abs(yTi-yTj-yTi(1)+yTj(1));
            case 2    % initialing & initial zero-starting
                yTij = abs(yTi./yTi(1)-yTj./yTj(1));
            otherwise % identical 
                yTij = abs(yTi-yTj);             % difference between splines
        end        
        dist(s-1) = sum((yTij(1:end-1)+yTij(2:end)).*diff(Tc) )/2; % integral
    end
    fgrd = exp(-gamma*sum(dist));
end









