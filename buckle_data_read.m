function data = buckle_data_read(direc)

    data = cell(4,3);

    for i = 1:4
        fname = [direc,num2str(5*i),'perc\'];
        cd(fname)
        %creates directory structure, to be filled with files found in directory
        dirinfo = dir();
        dirinfo(~[dirinfo.isdir]) = [];
        subdirinfo = cell(length(dirinfo));

        %create subdirinfo by reading all files, that are not directories
        for k = 1: length(dirinfo)
            thisdir = dirinfo(k).name;
            subdirinfo{k} = dir(fullfile(thisdir, '*.asc'));
        end

        X = cell(length(subdirinfo{1}),1);
        Y = cell(length(subdirinfo{1}),1);
        F = cell(length(subdirinfo{1}),1);

        for j = 1:length(subdirinfo{1})
            fid = fopen([fname,getfield(subdirinfo{1}(j),'name')]);
            data_pre = textscan(fid,'%f', 'Delimiter','\t','HeaderLines',14);
            X(j) = {data_pre{1}(1:2:(end-1))};
            Y(j) = {data_pre{1}(2:2:end)};
            F(j) = {getfield(subdirinfo{1}(j),'name')};
        end
        data(i,:) = {X,Y,F};
        fclose('all');
    end
end