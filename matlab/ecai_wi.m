X = [5 10 15 20 25]; %K
Y = [2 3 4 5]; %k for k-nn
Z = [ 0.967332700064449 0.9677619681011513 0.9677942533697489 0.9677568798854282 0.9676497203448129;
      0.967332700064449 0.9677619681011513 0.9677942533697489 0.9677568798854282 0.9676497203448129;
      0.967332700064449 0.9677619681011513 0.9677942533697489 0.9677568798854282 0.9676497203448129;
      0.967332700064449 0.9677619681011513 0.9677942533697489 0.9677568798854282 0.9676497203448132]; %R-squared

Z1 = [ 11.9519 11.83 11.8271 11.8274 11.8573;
       11.9519 11.83 11.8271 11.8274 11.8573;
       11.9519 11.83 11.8271 11.8274 11.8573;
       11.9519 11.83 11.8271 11.8274 11.8573
    ]; %Relative absolute error 

% figure;
% bar3(Z);


%surf(X,Y,Z);
% set(gca(gcf), 'xticklabel',X);
% set(gca(gcf), 'yticklabel',Y);


figure;
% subplot(1,2,1)
% %[X,Y,Z] = meshgrid(X,Y,Z);
% surf(X,Y,Z);
% %mesh(X,Y,Z); %interpolated
% 
% axis tight; hold on
% set(gca,'YTick',2:1:5)
% set(gca,'XTick',5:5:25)
% 
% xlabel('k_{dm}')
% ylabel('k_{nn}')
% zlabel('R^2')
% 
% title('R^2 values for different k_{dm} and k_{nn}')
% 
% subplot(1,2,2)
%[X,Y,Z] = meshgrid(X,Y,Z);
surf(X,Y,Z1);
%bar3(Z1);
%mesh(X,Y,Z1); %interpolated
alpha(0.5);

axis tight; hold on
set(gca,'YTick',2:1:5)
set(gca,'XTick',5:5:25)

xlabel('k_{dm}')
ylabel('k_{nn}')
zlabel('Relative Error (%)')

title('Relative errors for different k_{dm} and k_{nn}')


hFig = figure(1);
%set(hFig, 'Position', [100 100 1200 500])
set(hFig, 'Position', [100 100 600 500])