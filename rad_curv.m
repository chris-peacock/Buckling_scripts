clear;
data = buckle_data_read('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\Theo_buckling_data\');
D = data(:,1:2);
Files = data(:,3);
P = cell(4,1);
F = cell(4,1);
data = cell(4,1);

%For each directory
for i = 1:length(D)
    points = {};
    filename = {};
    p = cell(length(D{i}),1);
    t = cell(length(D{i}),1);
    %For each file in directory
    for j = 1:length(D{i})
        X = cell2mat(D{i,1}(j));
        Y = cell2mat(D{i,2}(j));
        filename = cat(1,filename,{string(Files{i}{j})});
        
        %number of points on each side of polynomial centre, to fit
        lpoly = 60;
        %number of points in running average (alterable with user input)
        n = 50;
        
        peakfinding = quadfit_profile(X,Y,lpoly,1,50);
        title(Files{i}{j})
        
        %Fit peaks, check for effective fitting
        q = input('good fit? (y = yes, w = up filter, s = down filter, a = up lpoly, d = down lpoly): ','s');
        while ~contains(q,["y","n"])
            if q == "w"
                n = n+10;
            elseif q == "s"
                n = n-10;
            elseif q == "a"
                lpoly = lpoly +10;
            elseif q == "d"
                lpoly = lpoly -10;
            end
            peakfinding = quadfit_profile(X,Y,lpoly,1,n);
            title(Files{i}{j})
            q = input('good fit? (y = yes, n = no, w = up filter, s = down filter, a = up lpoly, d = down lpoly): ','s');
        end
        
        if q == "n"
            peakfinding = {[nan,nan,nan],[nan,nan,nan]};
        end
        
        points = cat(1,points,peakfinding)
    end
    A = cat(2,filename,points);
    if size(A)
        B = {'file','peaks','troughs'};
        data(i) = {cell2struct(A,B,2)};
    end
end
fclose('all')
save('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\Theo_buckling_data\curvature.mat','data')