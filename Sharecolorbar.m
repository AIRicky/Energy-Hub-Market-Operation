clc, clear, close all;

top_margin = 0.03; % top margin
btm_margin = 0.03; % bottom margin
left_margin = 0.03;% left margin
right_margin = 0.15;% right margin

fig_margin = 0.08; % margin beween figures(sub) 

row = 4; % rows
col = 3; % cols

% Generate some test data to show
x = 0 : 1: 6; 
y = 0 : 1.5: 9;

f = y' * x;

% '54' and '0' respectively represent max(f) and min(f)
% both need to be calculated or traversed to determine
% for convenience, I directly use results
clim = [0 54];

% Calculate figure height and width according to rows and cols 
fig_h = (1- top_margin - btm_margin - (row-1) * fig_margin) / row;
fig_w = (1 - left_margin - right_margin - (col-1) * fig_margin) / col;

for i = 1 : row
    for j = 1 : col
        % figure position: you can refer to 'help axes' to review the
        % parameter meaning, note that original point is lower-left
        position = [left_margin + (j-1)*(fig_margin+fig_w), ...
           1- (top_margin + i * fig_h + (i-1) * fig_margin), ...
           fig_w, fig_h]
       axes('position', position)
       % draw colorful pictures... 
       imagesc(f, clim); 
       
       % title, labels
       title(['fig' num2str((i-1)*row+j)]);
       xlabel(['row:' num2str(i)]);
       ylabel(['col:' num2str(j)]);
    end   
end
% draw colorbar
axes('position', [1-right_margin-fig_margin, btm_margin, 0.2, 1-(top_margin+btm_margin)]);
axis off;
colorbar();caxis(clim);