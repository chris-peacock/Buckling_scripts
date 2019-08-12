clear;
clc;
load('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\Theo_buckling_data\curvature.mat')
R_cells = cell(4,1);
D_cells = cell(4,1);
A_cells = cell(4,1);
Peaks_cells = cell(4,1);
Troughs_cells = cell(4,1);
for i = [1,3,4]
    R = [];
    D = [];
    A = [];
    Peaks_av = [];
    Troughs_av = [];
    for j = 1:length(data{i})
        P = data{i}(j).peaks;
        T = data{i}(j).troughs;
        P_r = P(:,1);
        T_r = T(:,1);

        %Remove all curvature measurements with wrong sign
        P_r(P_r>0) = NaN;
        T_r(T_r<0) = NaN;
        P(:,1) = P_r;
        T(:,1) = T_r;
        
        P_av = mean(P(:,1),'omitnan');
        T_av = mean(T(:,1),'omitnan');
        D_av = mean(diff(P(:,2)),'omitnan');
        A_av = mean(P(:,3),'omitnan') - mean(T(:,3),'omitnan');
        R = [R P_av/T_av];
        D = [D D_av];
        A = [A A_av];
        Peaks_av = [Peaks_av P_av];
        Troughs_av = [Troughs_av T_av];
    end
    R_cells(i) = {R};
    D_cells(i) = {transpose(D)};
    A_cells(i) = {transpose(A)};
    Peaks_cells(i) = {transpose(Peaks_av)}
    Troughs_cells(i) = {transpose(Troughs_av)};
end

for i = [1,3,4]
    figure(1)
    plot(D_cells{i},abs(R_cells{i}),'o')
    xlabel('wavelength (nm)')
    ylabel('Rad. curv peak/ Rad. curv trough')
    hold on;

    figure(2)
    plot(A_cells{i},abs(R_cells{i}),'o')
    xlabel('2 * amplitude (nm)')
    ylabel('Rad. curv peak/ Rad. curv trough')
    hold on;

    figure(3)
    plot(D_cells{i},A_cells{i},'o')
    ylabel('2 * amplitude (nm)')
    xlabel('wavelength (nm)')
    hold on;
    
    figure(4)
    plot(D_cells{i},Peaks_cells{i},'o')
    ylabel('Peaks rad curv (nm)')
    xlabel('wavelength (nm)')
    hold on;
    
    figure(5)
    plot(D_cells{i},Troughs_cells{i},'o')
    ylabel('Peaks rad curv (nm)')
    xlabel('wavelength (nm)')
    hold on;
end