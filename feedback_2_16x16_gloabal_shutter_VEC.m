%           image sensing simulation (implementing GLOBAL Shutter) 
%           code creates VEC file for control signals of pixels

%   Structure to follow:
%   1. one row timing (common signals for each row: rst, ts, sf_bias, rs)
%   2. induvidual pixel coulmn readout (readout through "col_sel" transistor )


clc;
clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

%                       'feedback_vec.txt'

%                           Pixel Array Size 
                                m=16; %rows
                                n=m; %columns
                            num_of_pixels = m*n;
%                        (number of WBCAPD = (m-1)*(n-1) )
                            

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%time and control signal cell initialization

num_of_gs_stages = 3; % rst fd, rst pd, feedback
gshutter_signals = 4; %number of elements in the vector time_stage used globally (tg, rst, sf_bias, so_sel)
rshutter_signals = 2*m; % rs and col_sel - (readout)
control_row = num_of_gs_stages + rshutter_signals;
control_col = 1+ gshutter_signals +rshutter_signals;
pixel_control = cell(control_row, control_col);

for i=1:control_row
    for j=1:control_col
        pixel_control{i,j}=0;
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global Shutter signals
%          time   tg      rst  sf_bias    so_sel     
% signals = [0      0       1       0       0        ;... %rst start
%            10     1       1       0       0        ;... %tg open
%            120    1       0       1       1        ;... %tg close + sf_bias,so_sel open
               %close all and begin readout
%           ];

t_fd_rst = 10;
t_pd_rst = 110;
%t_feedback = 110; %equal to image sensing integration time
%t_feedback = 60;   % short feedback time
%t_feedback = 200;   % long feedback time
t_feedback = 500;   % longer feedback time

t_gs = t_fd_rst + t_pd_rst + t_feedback;

pixel_control{1,3}=1;
pixel_control{2,1}=t_fd_rst;
pixel_control{2,2}=1;
pixel_control{2,3}=1;
pixel_control{3,1}=t_fd_rst + t_pd_rst;
pixel_control{3,2}=1;
pixel_control{3,4}=1;
pixel_control{3,5}=1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add time values for readout
read_period = 1;

k=0;
for i=4:control_row
    pixel_control{i,1}= t_gs + k*read_period;
    k=k+1;
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   constant open col_sel during readout for all columns

for i=4:control_row
    for j=7:2:control_col
        pixel_control{i,j}= 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Open rs for each row readout
k=6;
for i=4:2:control_row
        pixel_control{i,k}= 1;
        k=k+2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%                   EXPORT TO VEC

% VEC File Structure
% radix ( 1 bit )
% io (inputs only)
% vname (tg<0> .... rst<0> .... sf_bias<0> ... rs<0> ........)
% trise
% tfall
% vih , vil, voh, vol
%time vector + signal matrix


fid = fopen('feedback_vec.txt','w'); %for testing
%fid = fopen('feedback_vec.vec','w');

fprintf(fid, 'radix\t');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       radix
for i=1:gshutter_signals + m*2
    fprintf(fid,'1 \t');
end
fprintf(fid, '\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       i/o
fprintf(fid, 'io \t');
for i=1:gshutter_signals + m*2
    fprintf(fid,'i \t');
end
fprintf(fid, '\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       vname
fprintf(fid, 'vname \t');
    fprintf(fid,'tg ');
    fprintf(fid,'rst ');
    fprintf(fid,'sf_bias ');
    fprintf(fid,'so_sel ');
for i=1:m
    fprintf(fid,'rs<');
    fprintf(fid,num2str(i-1));
    fprintf(fid,'> ');

    fprintf(fid,'col_sel<');
    fprintf(fid,num2str(i-1));
    fprintf(fid,'> ');
end
   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       unit step parameters
fprintf(fid,'\n');
fprintf(fid,'tunit \t us \n');
fprintf(fid,'trise \t 0.005 \n');
fprintf(fid,'tfall \t 0.005 \n');
fprintf(fid,'vih \t 1.8 \n');
fprintf(fid,'vil \t 0 \n');
fprintf(fid,'voh \t 1.8 \n');
fprintf(fid,'vol \t 0 \n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       PIXEL CONTROL SIGNALS FINAL MAT

for i=1:control_row
    for j=1:control_col
        fprintf(fid, num2str(pixel_control{i,j}));
        fprintf(fid,'\t');
        if j==1
            fprintf(fid,'\t');
        end
    end
    fprintf(fid,'\n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       END SIM


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       


fclose (fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

