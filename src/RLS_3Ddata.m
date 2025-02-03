clear all

%%===============importdata ======================================%
filename = 'Barbados';                               % importdata File name

data = importdata([filename,'.pro']);               
%=================================================================%

%========= Select the parameters of the calculation================%
% par = 1,Maximum residual; 
% par = 2,RMS roughness; 
% par = 3,Fractal-dimension;
par  = 1;
%%=========Setting output file ====================================%
if (par == 1)
fid = fopen([filename, '-MR.pro'],'w');
print('Maximum residual');
end
if (par == 2)   
fid = fopen([filename, '-RMS.pro'],'w');
print('RMS roughness');
end
if (par == 3)   
fid = fopen([filename, '-AP.pro'],'w');
print('Fractal-dimension');
end
%==================================================================%



%===============Reshape data========================================%      
for i =  1:1:length(data(:,1))-1
if (data(i,1)-data(i+1,1) ==0)
l(i) = 0;
else 
l(i) = 1;
end
end
s =find(l==1);
s =[1,s,length(data(:,1))];                             % Reshaped data
%===================================================================%

%===============loop computation for each 3D section= ==============%
  for j = 2:1:length(s)
  
line = data(s(j-1)+1,1);                                % No.inline 
dis  = data(s(j-1)+1:s(j),3);                           % Distance      (m)
dep  = data(s(j-1)+1:s(j),4);                           % Depth         (m)
% 
disp(line);

%======================Iteration parameters ===========================%
times = 2;                                              % Iteration times (when par ==3, time == 46)
t1=1000/(dis(end,1)-dis(1,1));                          % Window length in first interation
te=10000/(dis(end,1)-dis(1,1));                         % Window length in last interation
t     = linspace(t1,te,times);                          % Space of interation (cell)
dx    = (dis(2,1)-dis(1,1));                            % Actual space of data (m)
%=======================================================================

for i = 1:1:times  
    d = t(i)*(dis(end,1)-dis(1,1));                     % window length (m)
    num = round(d/dx) ;                                 % each window cell number
    windnum = round(length(dis(:,1))/num,0);            % Number of Windows
% If the last window is smaller than the given length
if (windnum*num >length(dep))
    windnum1 = windnum-1;                               % Number of Windows (except the last window)
else
    windnum1 = windnum;                                 
end
 
    for k = 1:1:windnum1
      
    dis2 = (dis((k-1)*num+1:(k)*num));                  % Distance in Given window 
    dep2 = (dep((k-1)*num+1:(k)*num));                  % Depth in Given window 
         

     %====Set the fitting options=========
    
     ft = fittype( 'poly1' );                           % Degree of a polynomial  
     [fitresult, gof] = fit( dis2,dep2, ft );
     res  = fitresult(dis2)-dep2;                       % Calculate the residual
     z(i,k) = (sum(res.^2)/(num-2))^0.5;
     z2 = sum(z(i,:)); 
     end
     %=== par ==2 or 3, Generate RMS    ===========
     if (par == 2 || par == 3 )
     z(i,k) = (sum(res.^2)/(num-2))^0.5;
     z2 = sum(z(i,:));                                  % Sum of RMS (except the last window)
     end
     %=== par ==1, Generate Max residuel ===========
     if  (par == 1)
     z2 = max(z(i,:));                                  % Maximum residual of the all given windows 
     end
     %=====The last window        ============ ====  
    dis1 = dis(end-num+1:end);
    dep1 = dep(end-num+1:end);
     %=====Set the fitting options =================
    ft1 = fittype( 'poly1' );                           % Degree of a polynomial  
    [fitresult1, gof1] = fit( dis1,dep1, ft1 );         
    res1  = fitresult1(dis1)-dep1;                      % Calculate the residual
    z1 = (sum(res1.^2)/num)^0.5;
    %======generate average RMS  ========
    if  (par == 2 || par == 3)
    rms(i) = (z2+z1)/windnum;       
    end
     % generate Max residuel    =========
    if  (par == 1)
    rms(i) = max(z2,z1);
    end
 end
 
% ========par ==3 ,Calcualte fractal dimension====================
%==========log(rms(nw)) = log(A) + Hlog(w)      ==================

% Where rms(w), nw, H and A are the standard deviation 
% of the profile height, the window length of a
% profile, the Hurst exponent and the amplitude parameter.
%=================================================================
if (par == 3)
w=t*(dis(end)-dis(1));                                  % Profiles length
nw=w/1000;                                              % Normalized window
x =log10(nw);                                           % Log10 of Window length
y =log10(rms);                                          % Log10 of Average of RMS 
[xData2, yData2] = prepareCurveData(x,y);
%=====Set the fitting options ======
ft = fittype( 'poly1');
 %=========Fitting===================
[fitresult3, gof] = fit( xData2, yData2, ft );
H = fitresult3.p1;                                      % The Hurst exponent
E = 2;                                                  % The Euclidean dimension (2 for 2D proflies)   
D = E-H;                                                % The fractal dimension
A1 = fitresult3.p2;                                     % Log10 of the amplitude parameter
A = 10^A1;                                              % The amplitude parameter



% ======print data into output file=======================
%   Lines A   D   rms(5km) rms(10km)
%   2053 0.5 0.5 49.9443 269.1531 
%   2054 0.5 0.5 43.5203 268.9595 
fprintf(fid,'%3.0f %4.4f %4.4f \r\n',line, rms);
fprintf(fid,'%3.0f %4.4f %4.4f %4.4f %4.4f \r\n',line, A,D, rms);
%=============================================================

 clear  dis dep a xData2 yData2 rms z1 z ft fitresult3 gof gof1 D A E z2 fitresult1 x y nw w res1 ft1 dis1 dep1
 clear  dis2 dep2 res fitresult gof3
 end
fclose(fid)
