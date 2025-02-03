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
    if ~isempty(strfind(filename{i},'\'))
        gp=strfind(filename{i},'\');
        auxo{i}=filename{i}(gp(end)+1:end);
    end
end

%%===============Setting output file =================%
fid = fopen('RM-output.txt','w')
fprintf(fid,'%4s %6s \r\n','Profile', 'RM 1-10 km');
%======================================================

for k=1:length(filename)
    disp(auxo{k});
    data=importdata(filename{k});
    dat = data; 
    dis  = dat(:,1);                            % Distance  (m)
    dep  = dat(:,2);                            % Depth     (m)
    a = find(isnan(dep)==0);                    % Find nan 
    dis  = dis(a);                              % Use non-empty collections
    dep  = dep(a);                              % Use non-empty collections
%======================Iteration ==========%
    times =46;                                   % Iteration times
  % p = linspace(1,10,46)
        t1 = 1000/(dis(end,1)-dis(1,1));       
        te = 10000/(dis(end,1)-dis(1,1));     
        t =  linspace(t1,te,times);              % Space of interation (cell)
        dx= (dis(2,1)-dis(1,1));                 % Actual space of data (m)
 for i = 1:1:times 
        d = t(i)*(dis(end,1)-dis(1,1));          % window length (m)
        num = round(d/dx) ;                      % Each window cell number
        windnum = round(length(dis(:,1))/num,0); % Number of window
     for j = 1:1:windnum-1
        dis2 = (dis((j-1)*num+1:(j)*num));
        dep2 = (dep((j-1)*num+1:(j)*num));
        
         %====Set the fitting options=========
        ft = fittype( 'poly1' );                % Degree of a polynomial  
        [fitresult,gof] = fit( dis2,dep2, ft );
        res  = fitresult(dis2)-dep2;            % Calculate the residual

        %===Generate Max residuel ===========
        z(i,j) = (max(res));                    % Maximum residual with in a single window
        % z2 = sum(z(i,:));         
        z2 =max(z(i,:));                        % Maximum residual of the all given windows 
     end
        %=====The last window ================  
        dis1 = dis(end-num+1:end);
        dep1 = dep(end-num+1:end);
         
        %=====Set the fitting options ====== 
        ft1 = fittype( 'poly1' );               % Degree of a polynomial  
        [fitresult1, gof1] = fit( dis1,dep1, ft1 );
        res1  = fitresult1(dis1)-dep1;          % Calculate the residual
        z1 = max(res1);
        % generate Max residuel    ==========
        rms(i) = max(z2,z1);
    
 end


        fprintf(fid,['%4s %2.4f %2.4f ' ...
        '%2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f ' ...
        '%2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f ' ...
        '%2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f ' ...
        '%2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f ' ...
        '%2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f %2.4f'],auxo{k}(1:end),rms);
        fprintf(fid, '\r\n');

clear  data dis dep a xData2 yData2 rms z1 z ft fitresult3 gof gof1 D A E z2 fitresult1 x y nw w res1 ft1 dis1 dep1
clear  dis2 dep2 res fitresult gof3
end

fclose(fid);
