function D = quadfit_profile(X,Y,lpoly,N,filtnum)
    %%%lpoly = number of points on each side of peak/trough to fit quad.
    %%%N = number of peak finding iterations
    %%%left = number of leftmost peaks/troughs to ignore
    %%%right = number of rightmost peaks/troughs to ignore
    %%%filtnum = number of datapoints in moving average
    
    left = 1;
    right = 1;
    %Running average filter
    Y_filt(1:(filtnum/2)) = Y(1) ;
    Y_filt((length(Y)-(filtnum/2)):length(Y)) = Y(end);


    for j = ((filtnum/2)+1):(length(Y)- (filtnum/2))
      Y_filt(j) = sum(Y((j-(filtnum/2)):(j+(filtnum/2))))/filtnum;
    end

    %[0; ... ;0] adds extra '0's at ends of array, to avoid diff running out of adjacent points to compare.  diff(diff()) is
    %essencially a 2nd deriv dX^2; if the abs(slope) decreases across adjacent points, considered peak 
    index_filt_p = find(real(diff(sign(real(diff([0; Y_filt(:); 0]))))) < 0);
    index_filt_t = find(real(diff(sign(real(diff([0; Y_filt(:); 0]))))) > 0);
    
    %Remove 'left' and 'right' number of peaks from ends (avoid edge effects)
    if (left>0 || right>0 || left>0 || right>0)
      index_filt_p = index_filt_p((left+1):((length(index_filt_p) - right)));
      index_filt_t = index_filt_t((left+1):((length(index_filt_t) - right)));
    end
    
    size(X)
    %Pad ends of profile with nans, so fitting can occur at any point
    X = [nan(lpoly,1); X; nan(lpoly,1)];
    Y = [nan(lpoly,1); Y; nan(lpoly,1)];
    index_filt_p = index_filt_p+lpoly;
    index_filt_t = index_filt_t+lpoly;

    %fit polynomials to peaks, with lpoly points on each side of peak point
    quadr_p = zeros(length(index_filt_p),3);
    x_p = zeros(length(index_filt_p),1);
    y_p = zeros(length(index_filt_p),1);
    for i = 1:length(index_filt_p)
      x_p(i) = X(index_filt_p(i));
      y_p(i) = Y(index_filt_p(i));
      quadr_p(i,:) = polyfit(X((index_filt_p(i)-lpoly):(index_filt_p(i)+lpoly)),Y((index_filt_p(i)-lpoly):(index_filt_p(i)+lpoly)),2);
      quadrpoints_p(i,:) = X((index_filt_p(i)-lpoly):(index_filt_p(i)+lpoly));
    end

    quadr_t = zeros(length(index_filt_t),3);
    x_t = zeros(length(index_filt_t),1);
    y_t = zeros(length(index_filt_t),1);
    for i = 1:length(index_filt_t)
      x_t(i) = X(index_filt_t(i));
      y_t(i) = Y(index_filt_t(i));
      quadr_t(i,:) = polyfit(X((index_filt_t(i)-lpoly):(index_filt_t(i)+lpoly)),Y((index_filt_t(i)-lpoly):(index_filt_t(i)+lpoly)),2);
      quadrpoints_t(i,:) = X((index_filt_t(i)-lpoly):(index_filt_t(i)+lpoly));
    end
    
    %%Here, output both radius of curvature and position of extrema
    R_p = quadr_p(:,1).^(-1);
    R_t = quadr_t(:,1).^(-1);
    
    %Store all radius of curvature values, and positions, in 2 x 3 cell
    %array
    D = {[R_p,x_p,y_p],[R_t,x_t,y_t]};

    figure(1)
    plot(X,Y)
    xlabel('length of profile (nm)')
    ylabel('Height (nm)')
    hold on;
    
    for j = 1:length(index_filt_p)
      plot(X(index_filt_p(j)),Y(index_filt_p(j)),'r*')
      hold on;
    end
    
    for j = 1:length(index_filt_t)
      plot(X(index_filt_t(j)),Y(index_filt_t(j)),'g*')
      hold on;
    end
    
    %Plot parabolas for peaks, to check fitting
    for j = 1:length(index_filt_p)
        length(quadrpoints_p(j,:))
      plot(quadrpoints_p(j,:),(quadr_p(j,1)*quadrpoints_p(j,:).^2 + quadr_p(j,2)*quadrpoints_p(j,:) + quadr_p(j,3)))
      hold on;
    end
    
    hold off;
end