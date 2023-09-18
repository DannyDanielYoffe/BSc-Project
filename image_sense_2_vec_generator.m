%           image sensing simulation (implementing Rolling Shutter) 
%           code creates VEC file for control signals of pixels

%   Structure to follow:
%   1. one row timing (common signals for each row: rst, ts, sf_bias, rs)
%   2. induvidual pixel coulmn readout (readout through "col_sel" transistor )
%   3. timing of row reset - depending on coulmn readout intervals 
%   4. timing of tow readout 

clc;
clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

%                       'image_sense_vec.txt'

%                           Pixel Array Size 
                                m=16; %rows
                                n=m; %columns
                            num_of_pixels = m*n;
%                        (number of WBCAPD = (m-1)*(n-1) )
                            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% times periods for transistor control (depends on "is_tb" simulation time values)
%time is in microsecond (us  = 10^-6 second)
t_init = 0;                    % initial time


% time periods of waveform
t_pre_reset_hold = 100;             % time to discharge FD node before opening TG for reset (per row) - open tg
tg_reset_period  = 300;             % period of time TG is open for reset stage (per row) - close tg
t_post_reset_hold = 100;            % time to discharge FD node after closing TG after reset (per row) - close rst
t_integration = 110;                % time for photodiode discharge (integration time)
t_sample_period = 110;              % time for sample and hold (tg open second time)
t_pre_read_hold = 20;               % time hold pre readout
t_row_read_period = 30;             % time for readout (rs open)

pixel_time = t_pre_reset_hold + tg_reset_period + t_integration + t_sample_period + t_pre_read_hold + t_row_read_period;
t_row_start = t_init;
time_stage = zeros(1,8) ;

time_stage = ...
    [t_row_start...                                                                                                             %1
    t_row_start + t_pre_reset_hold...                                                                                           %2
    t_row_start + t_pre_reset_hold + tg_reset_period...                                                                         %3
    t_row_start + t_pre_reset_hold + tg_reset_period + t_post_reset_hold...                                                     %4
    t_row_start + t_pre_reset_hold + tg_reset_period + t_integration...                                                         %5
    t_row_start + t_pre_reset_hold + tg_reset_period + t_integration + t_sample_period...                                       %6
    t_row_start + t_pre_reset_hold + tg_reset_period + t_integration + t_sample_period + t_pre_read_hold...                     %7
    t_row_start + t_pre_reset_hold + tg_reset_period + t_integration + t_sample_period + t_pre_read_hold + t_row_read_period... %8

    
    ];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%time and control signal cell initialization

pixel_control = cell(8 * m +1, 1 + 5 * m);
for i=1:8*m
    for j=1:(5*m+1)
        pixel_control{i,j}=0;
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%                      TIME VECTOR
k=0;
t_stage = 0;
row_delay = 30;
for i=1:m
    for j=1:8
        pixel_control{i+k+j-1,1} = time_stage(j) + t_stage;
    end
    t_stage =  i*pixel_time + row_delay*i;
    k=k+7;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                        % PER ROW CONTROL SIGNALS
           %tg      rst  sf_bias     rs   col_out
signals = [ 0       1       0       0       0     ;...
            1       1       0       0       0     ;...
            0       1       0       0       0     ;...
            0       0       0       0       0     ;...
            1       0       0       0       0     ;...
            0       0       0       0       0     ;...
            0       0       0       1       1     ;...
            0       0       0       0       1    ]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   ASSIGN CONTROL SIGNALS PER ROW OF PIXELS

for i =1:m
    for k=1:5
        for j=1:8
            pixel_control{(i-1)*8+j,(i-1)*5+1+k}= signals(j,k);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   COLUMN OUT CONTROL 

for i =1:8*m
    for j=1:5*m+1
        %open all  col transistor during readout
        pixel_control{(i-1)*8+8,(j-1)*5+6}=1; % signal(8,5) = 1
        pixel_control{(i-1)*8+7,(j-1)*5+6}=1; % signal(7,5) = 1
        %simultanious row reset
        pixel_control{(i-1)*8+3,(j-1)*5+3}=1; % signal(1,2) = 1
        pixel_control{(i-1)*8+2,(j-1)*5+3}=1; % signal(2,2) = 1
        pixel_control{(i-1)*8+1,(j-1)*5+3}=1; % signal(3,2) = 1
    end
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


fid = fopen('image_sense_vec_v1.vec','w');


fprintf(fid, 'radix\t');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       radix
for i=1:m*5
    fprintf(fid,'1 \t');
end
fprintf(fid, '\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       i/o
fprintf(fid, 'io \t');
for i=1:m*5
    fprintf(fid,'i \t');
end
fprintf(fid, '\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       vname
fprintf(fid, 'vname \t');
for i=1:m
    fprintf(fid,'tg<');
    fprintf(fid,num2str(i-1));
    fprintf(fid,'> \t');

    fprintf(fid,'rst<');
    fprintf(fid,num2str(i-1));
    fprintf(fid,'> \t');
    
    fprintf(fid,'sf_bias<');
    fprintf(fid,num2str(i-1));
    fprintf(fid,'> \t');

    fprintf(fid,'rs<');
    fprintf(fid,num2str(i-1));
    fprintf(fid,'> \t');

    fprintf(fid,'col_sel<');
    fprintf(fid,num2str(i-1));
    fprintf(fid,'> \t');

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

for i=1:8*m
    for j=1:(5*m+1)
        fprintf(fid, num2str(pixel_control{i,j}));
        fprintf(fid,'\t');
        if j==1
            fprintf(fid,'\t');
        end
    end
    fprintf(fid,'\n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       END SIM

fprintf(fid,num2str(pixel_control{m*8,1} + row_delay));
fprintf(fid,'\t \t');
for i=2:(5*m+1)
    fprintf(fid,'0 \t');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       


fclose (fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

