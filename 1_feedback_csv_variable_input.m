%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% WBCAPD project - image sensing simulation variables - ".csv" file generator 

%   Instructions:
%   1.  Matlab Code: change variables: i_min, max_photo_current, m, n
%                    output: ".cvs" file (to be imported to Virtuoso>>Maestro)
%   2.  Transfer file to ws.
%   3.  Open file, save file : "Use Text CSV Format" , click OK.
%   4.  Open Virtuoso -> Maestro. right click on "Design Variables" -> import from CSV."

%   NOTE: if you wish to upload an image, use the code in section 4,
%         otherwise see section 2 and 3.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%                  1. Initial Values for Simulation  

% greyscale value of matlab per image pixel =[0,255]

%           Minimal & Maxminal Photo Current
i_min = 1e-18; % [A] (1aA)
i_max = 170e-12; % [A] (170pA)

sizing_factor = 1/255;

%            wbcapd array dimension (mxn) (one less than Pixel Array dimensions)
m = 15;     
n = 15;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%      2.  Matrix initialization

% Defualt - 0 -  Min photocurrent
img_in = zeros(m,n);

% 255 - Max photocurrent
%img_in = 255* ones(m,n);

% 128 - half power photocurrent (middle)
%img_in = 128* ones(m,n);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        3.     image - [0,255,0,0] for n=2 


%          (square with top right quarter black)


% for i = 1:m
%     for j = 1:n
%         if(i<=round(m/2) && j>round(n/2))
%             img_in(i, j) = 255;
%         end
%     end
% end



%          top half 255, bottom half 0


for i = 1:m
    for j = 1:n
        if(i<=round(m/2))
            img_in(i, j) = 255;
        end
    end
end

% %          gradation horizontal
% 
% for i = 1:m
%     for j = 1:n
%         img_in(i, j) = (j/n)*255;
%      end
% end

%          gradation vertical

% for i = 1:m
%     for j = 1:n
%         img_in(i, j) = (i/m)*255;
%      end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     4.  Import (mxn) Image from path

%A = imread(img2);
%img_in = rgb2gray(A);
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
                  %'variable','L_col_sel',       '20*180n', 'enabled','' ,'';

                  'variable','N', '1', 'enabled','' ,'';

                  'variable','W_cm',         '220n', 'enabled','' ,'';
                  'variable','W_tg',         '220n', 'enabled','' ,'';
                  'variable','W_rst',        '220n', 'enabled','' ,'';
                  'variable','W_sf',         '3*220n', 'enabled','' ,'';
                  'variable','W_bias',       '220n', 'enabled','' ,'';
                  'variable','W_rs',         '3*220n', 'enabled','' ,'';
                  'variable','W_so',         '220n', 'enabled','' ,'';
                  'variable','W_col_sel',    '220n', 'enabled','' ,'';

                  'variable','c_pd',    '28.08f', 'enabled','' ,'';   %    Emulated PD Capacitance (WBCAPD cell)
                  'variable','c_fd',    '17f', 'enabled','' ,'';      %    Floating Diffusion Capacitance (is_tb cell)
                  %'variable','c_col',   '40f', 'enabled','' ,'';     %    column capacitance sim (is_tb_4port_pixel)

                  'variable','v_ref',   '500m', 'enabled','' ,'';    %    Emulated PD saturation voltage (WBCAPD cell)

                  'variable','i_in_D',  '0', 'enabled','' ,'';
                  'variable','i_in_P',  '20m', 'enabled','' ,'';
                  'variable','i_in_PW', '15m', 'enabled','' ,'';
                  'variable','i_in_RF', '10n', 'enabled','' ,'';
                  
                  
                  };
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%   7.  Image-Current Values data for csv table file
str = 'i_in%d';
current_block = cell(n*n, 6);
for i = 1:(m*n)
    current_block(i,:) = {'variable',sprintf(str,i-1),i_in(i), 'enabled','',''};
end

%   8.  write data to cvs file
data = title_row;
data = vertcat (data, variable_block); 
data = vertcat (data, current_block);

writecell (data,'feedback_parameters_input.csv');





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

