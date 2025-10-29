clear all


%%==================Read list file==============
        filename = importdata("list");

for i=1:length(filename)
    % if ~isempty(strfind(filename{i},','))
    %     bp=strfind(filename{i},',');
    % 
    %     aux{i}=filename{i}(bp(1)+1:end);
    % else
    %     bp=strfind(filename{i},' ');
    % 
    %     aux{i}=filename{i}(bp(end)+1:end);
    % end
    %     auxo{i}=aux{i};
    if ~isempty(strfind(filename{i},'/'))
        gp=strfind(filename{i},'/');
        auxo{i}=filename{i}(gp(end)+1:end);
    end
end

%%===============Setting output file =================%
        fid = fopen('outputi50wnocut.txt','w')
        fprintf(fid,'%4s %6s %6s %6s  \r\n','Profile', 'Amplitude-parameter', 'Fractal-dimension','RMS-roughness (1-10 km)');
%======================================================
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
        nw=w/1;                                         % Normalized window
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
        A = fitresult3.p2;                              % Log10 of the amplitude parameter

%==========Plot the data fitting map================
        figure(1)

        h = plot( fitresult3, xData2, yData2);
        legend( h, 'raw data', 'Least squares fit', 'Location', 'NorthWest', 'Interpreter', 'none' );
        xlabel( 'log(window lenght) (m)', 'Interpreter', 'none' );
        ylabel( 'log(RMS roughness)', 'Interpreter', 'none' );
        % title(['Profile ' auxo{k}(1:end-5)],['from ',num2str(t1*100),' % to ',num2str(te*100),' % ']);
        % txt = ['y = ',num2str(H),'x',' ',num2str(A)];
        % text(x(4)+0.2,y(4),txt);
        axis equal
        grid on
        hold on 

        % fprintf(fid,['%4s %2.4f %2.4f'],auxo{k}(1:end-5), A, D);
        % fprintf(fid,['%4s %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f'],auxo{k}(1:end-5), A, D,rms);
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

        fclose(fid);
