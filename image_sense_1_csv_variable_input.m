%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WBCAPD project - image sensing simulation variables - ".csv" file generator 

%   Instructions:
%   1.  Matlab Code: change variables: i_min, max_photo_current, m, n
%                    output: "simulation_parameters.csv" file (to be imported to Virtuoso>>Maestro)
%   2.  Transfer file to ws.
%   3.  Open file, save file : "Use Text CSV Format" , click OK.
%   4.  Open Virtuoso -> Maestro. right click on "Design Variables" -> import from CSV."

%   NOTE: if you wish to upload an image, use the code in section 4,
%         otherwise see section 2 and 3.


%                  1. Initial Values for Simulation  
%           Minimal & Maxminal Photo Current
i_min = 1e-18; % [A] 
max_photo_current = 200e-12; % [A] 
i_max = max_photo_current;
sizing_factor = 1/255;
%            wbcapd array dimension (mxn) 
m = 15;     
n = m;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      2.  Matrix initialization
A = imread('image.bmp');
img_in = rgb2gray(A);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   5.  Calculate Current Values from greyscale
img_in_t=img_in';
val = reshape(img_in_t, 1, []);
i_in = i_min + (i_max-i_min) * sizing_factor * val;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        6.   Variable Setting
%table title
title_row = {'Type', 'Name', 'Value', 'Enabled', 'Tags', 'Notes'};
%Simulation Variables
variable_block = {'variable','vdd', '1.8', 'enabled','' ,'' ;
                  'variable','vss', '0', 'enabled','' ,'' ;
                  'variable','L_cm',            '180n', 'enabled','' ,'';
                  'variable','L_tg',            '180n', 'enabled','' ,'';
                  'variable','L_rst',           '300n', 'enabled','' ,'';
                  'variable','L_sf',            '300n', 'enabled','' ,'';
                  'variable','L_bias',          '180n', 'enabled','' ,'';
                  'variable','L_rs',            '180n', 'enabled','' ,'';
                  'variable','L_so',            '180n', 'enabled','' ,'';
                  'variable','L_col_sel',       '30*180n', 'enabled','' ,'';
                  'variable','N',                '1',       'enabled','' ,'';
                  'variable','W_cm',            '220n', 'enabled','' ,'';
                  'variable','W_tg',            '220n', 'enabled','' ,'';
                  'variable','W_rst',           '220n', 'enabled','' ,'';
                  'variable','W_sf',            '3*220n', 'enabled','' ,'';
                  'variable','W_bias',          '220n', 'enabled','' ,'';
                  'variable','W_rs',            '3*220n', 'enabled','' ,'';
                  'variable','W_so',            '220n', 'enabled','' ,'';
                  'variable','W_col_sel',       '220n', 'enabled','' ,'';
                  'variable','c_pd',            '28.08f', 'enabled','' ,'';   
                  'variable','c_fd',            '17f', 'enabled','' ,'';     
                  'variable','c_column',        '40f', 'enabled','' ,'';    
                  'variable','v_ref',           '500m', 'enabled','' ,'';    
                  'variable','i_in_D',  '0', 'enabled','' ,'';
                  'variable','i_in_P',  '20m', 'enabled','' ,'';
                  'variable','i_in_PW', '15m', 'enabled','' ,'';
                  'variable','i_in_RF', '10n', 'enabled','' ,'';
                  };
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   7.  Image-Current Values data for csv table file
str = 'i_in%d';
current_block = cell(n*n, 6);
for i = 1:(m*n)
    current_block(i,:) = {'variable',sprintf(str,i-1),i_in(i), 'enabled','',''};
end
image(img_in)
colorbar

%   8.  write data to cvs file
data = title_row;
data = vertcat (data, variable_block); 
data = vertcat (data, current_block);
writecell (data,'simulation_parameters.csv');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

