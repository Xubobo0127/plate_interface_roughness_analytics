clear all
close all
clc

%% ================== Read list file ==================
filename = importdata("list");

auxo = cell(size(filename));
for i = 1:length(filename)
    if ~isempty(strfind(filename{i}, '\'))
        gp = strfind(filename{i}, '\');
        auxo{i} = filename{i}(gp(end)+1:end);
    else
        auxo{i} = filename{i};
    end
end

%% ================== Figure settings ==================
profilesPerPanel = 4;
numProfiles = length(filename);
numPanels = ceil(numProfiles / profilesPerPanel);

fig = figure('Color', 'w', 'Units', 'centimeters', ...
    'Position', [2, 2, 26, 22]);   

ts = tiledlayout(3, 3, ...
    'TileSpacing', 'tight', ...
    'Padding', 'tight');

% Font settings
fontNameMain   = 'Arial';    % change to 'Helvetica' if preferred on Mac
fontSizeAxis   = 8;
fontSizeTitle  = 9;
fontSizeLegend = 7;
fontSizeGlobal = 11;

% Line width settings
axisLineWidth = 0.8;
fitLineWidth  = 1.0;
dataLineWidth = 0.8;
markerSize    = 4.5;

% Marker / line styles
markerSet = {'o','s','d','^','v','>','<','p','h','x','+','*'};
lineSet   = {'-','-','-','-'};
colorSet  = lines(profilesPerPanel);

%% ================== Output file ==================
fid = fopen('outputi50wnocut.txt', 'w');
fprintf(fid, '%4s %6s %6s %6s\r\n', ...
    'Profile', 'Amplitude-parameter', 'Fractal-dimension', 'RMS-roughness (1-10 km)');

%% ================== Main loop ==================
  for k=1:length(filename)
        disp(auxo{k});
        data=importdata(filename{k});                  
        dat = data; 
        dis  = dat(:,1);                                % Distance  (m)
        dep  = dat(:,2);                                % Depth     (m)
        a = find(isnan(dep)==0);                        % Find nan 
        dis  = dis(a);                                  % Use non-empty collections
        dep  = dep(a);                                  % Use non-empty collections
%======================Iteration ==========%
        times =46;                                      % Iteration times
        t1=1000/(dis(end,1)-dis(1,1));                  % Minimum window
        te=10000/(dis(end,1)-dis(1,1));                 % Maximum window
        t = linspace(t1,te,times);                      % Space of interation (cell)
        dx = (dis(2,1)-dis(1,1));                       % Actual space of data (m)
 for i = 1:1:times 
   
        d = t(i)*(dis(end,1)-dis(1,1));                 % window length (m)
        num = round(d/dx) ;                             % Each window cell number
        windnum = round(length(dis(:,1))/num,0);        % Number of window
     for j = 1:1:windnum-1
        dis2 = (dis((j-1)*num+1:(j)*num));
        dep2 = (dep((j-1)*num+1:(j)*num));
        
        %====Set the fitting options=========
        ft = fittype( 'poly1' );                        % Degree of a polynomial  
        [fitresult,gof] = fit( dis2,dep2, ft );
        res  = fitresult(dis2)-dep2;                    % Calculate the residual

        %===Generate Root-mean-square (RMS)== 
        z(i,j) = (sum(res.^2)/(num))^0.5;               % RMS
        z2 = sum(z(i,:));                               % Sum of RMS (except the last window)
      
     end
       %=====The last window ================  
        dis1 = dis(end-num+1:end);
        dep1 = dep(end-num+1:end);
          
        %=====Set the fitting options ======
        ft1 = fittype( 'poly1' );                       % Degree of a polynomial  
        [fitresult1, gof1] = fit( dis1,dep1, ft1 );
        res1  = fitresult1(dis1)-dep1;                  % Calculate the residual
        z1 = (sum(res1.^2)/(num-1))^0.5;                % RMS of Last window   
        %======generate average RMS  ========
        rms(i) = (z2+z1)/windnum;                       % Average of RMS (every windows)
     end

% ========Calcualte fractal dimension====================
%==========log(rms(nw)) = log(A) + Hlog(w)==================

% Where rms(w), nw, H and A are the standard deviation 
% of the profile height, the window length of a
% profile, the Hurst exponent and the amplitude parameter.
%===========================================================
        w=t*(dis(end)-dis(1));                          % Profiles length
        nw=w/1000;                                      % Normalized window
        x =log10(nw);                                   % Log10 of Window length
        y =log10(rms);                                  % Log10 of Average of RMS 
        [xData2, yData2] = prepareCurveData(x,y);
        %=====Set the fitting options ======
        ft3 = fittype( 'poly1' );
        %=========Fitting===================
        [fitresult3, gof3] = fit( xData2, yData2,ft3);
        H = fitresult3.p1;                              % The Hurst exponent
        E = 2;                                          % The Euclidean dimension (2 for 2D proflies)
        D = E-H;                                        % The fractal dimension
        A = 10^(fitresult3.p2);                         % The amplitude parameter


%% ================== Plotting ==================
    panelIdx = ceil(k / profilesPerPanel);
    ax = nexttile(panelIdx);
    hold(ax, 'on');

    localIdx = mod(k-1, profilesPerPanel) + 1;

    thisColor  = colorSet(localIdx, :);
    thisMarker = markerSet{mod(localIdx-1, length(markerSet)) + 1};
    thisLine   = lineSet{mod(localIdx-1, length(lineSet)) + 1};

    % ---------- Plot raw data ----------
    plot(ax, x, y, ...
        'LineStyle', 'none', ...
        'Marker', thisMarker, ...
        'MarkerSize', markerSize, ...
        'LineWidth', dataLineWidth, ...
        'Color', thisColor, ...
        'HandleVisibility', 'off');

    % ---------- Plot fitted line ----------
    xfit = linspace(min(x), max(x), 200);
    yfit = fitresult3.p1 * xfit + fitresult3.p2;

    plot(ax, xfit, yfit, ...
        'LineStyle', thisLine, ...
        'LineWidth', fitLineWidth, ...
        'Color', thisColor, ...
        'DisplayName', sprintf('%s (D=%.3f)', auxo{k}(1:end-4), A));

    % ---------- Axes basic style ----------
    set(ax, ...
        'FontName', fontNameMain, ...
        'FontSize', fontSizeAxis, ...
        'LineWidth', axisLineWidth, ...
        'TickDir', 'out', ...
        'TickLength', [0.015 0.015], ...
        'Layer', 'top');
    axis([0 1 0 2.4])
    grid(ax, 'off');
    box(ax, 'on');

    % ---------- Determine row and column ----------
    row = ceil(panelIdx / 3);
    col = mod(panelIdx - 1, 3) + 1;

    % 
    ax.XAxis.Visible = 'on';
    ax.YAxis.Visible = 'on';
    % ax.XTick = [];
    % ax.YTick = [];

    % 
    if col == 1
        ax.YAxis.Visible = 'on';
        ax.YTickMode = 'auto';
    end

    % 
    if row == 3
        ax.XAxis.Visible = 'on';
        ax.XTickMode = 'auto';
    end

    % 
    if (col == 1) || (row == 3)
        box(ax, 'on');
    end

    %% ---------- Subplot title ----------
    startIdx = (panelIdx-1) * profilesPerPanel + 1;
    endIdx   = min(panelIdx * profilesPerPanel, numProfiles);

    % title(ax, sprintf('Profiles %d-%d', startIdx, endIdx), ...
    %     'FontName', fontNameMain, ...
    %     'FontSize', fontSizeTitle, ...
    %     'FontWeight', 'normal');

    legend(ax, 'Location', 'best', ...
        'Interpreter', 'none', ...
        'Box', 'off', ...
        'FontName', fontNameMain, ...
        'FontSize', fontSizeLegend);

%% ================== Write results ==================
        fprintf(fid,['%4s %2.4f %2.4f ' ...
            '%2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f ' ...
            '%2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f ' ...
            '%2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f ' ...
            '%2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f ' ...
            '%2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f '],auxo{k}(1:end-5), A, D,rms);
        fprintf(fid, '\r\n');

        clear  data dis dep a xData2 yData2 rms z1 z ft fitresult3 gof gof1 D A E z2 fitresult1 x y nw w res1 ft1 dis1 dep1
        clear  dis2 dep2 res fitresult gof3

end

%% ================== Global labels ==================
xlabel(ts, 'Log_{10}(normalized window length (m)) ', ...
    'FontName', fontNameMain, ...
    'FontSize', fontSizeGlobal, ...
    'FontWeight', 'normal');

ylabel(ts, 'Log_{10}(RMS (m)) ', ...
    'FontName', fontNameMain, ...
    'FontSize', fontSizeGlobal, ...
    'FontWeight', 'normal');

title(ts, 'Log-Log RMS Roughness (1-10 km) for 35 Profiles', ...
    'FontName', fontNameMain, ...
    'FontSize', fontSizeGlobal + 1, ...
    'FontWeight', 'bold');

%% ================== Close output file ==================
fclose(fid);