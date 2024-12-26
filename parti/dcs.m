function dy = dcs(t,y,T,ord)
% derivative cubic splines
%   t: time index -column vector 
%  yt: observations -column vector
%   T: interpolation time index -column vector
% ord: ord-th derivative of cubic splines -integer

    if nargin==3
        T = linspace(t(1),t(end),200)';
    end
    
    sf = spline(t,y);         % spline functions
    pf = cell(sf.pieces,1);   % piecewise functions
    switch ord
        case 0
            for i=1:sf.pieces
                pf{i,1} = @(t)sf.coefs(i,1:end)*((t-sf.breaks(i)).^(3:-1:0)' );    
            end
        case 1
            for i=1:sf.pieces
                pf{i,1} = @(t)[3 2 1].*sf.coefs(i,1:end-1)*((t-sf.breaks(i)).^(2:-1:0)' );    
            end
        case 2
            for i=1:sf.pieces
                pf{i,1} = @(t)  [6 2].*sf.coefs(i,1:end-2)*((t-sf.breaks(i)).^(1:-1:0)' );    
            end
    end
    
    dy = zeros(size(T));
    for k=1:length(T)-1
        tk = T(k);
        % find the number of piecewise functions
        idx = find(sf.breaks(1:end-1)'<=tk & tk<sf.breaks(2:end)' );
        dy(k) = pf{idx}(tk);
    end
    % specify the last point
    dy(end) = pf{idx}(T(end));

end





















