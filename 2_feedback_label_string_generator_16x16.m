
clc;
clear;



 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%                                   WBCAPD array initialization & connectivity
%                                           
%                                               

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Pixel Wiring instructions:

%   1.  set pixel array dimensions (mxn)
%   2.  open output excel file "is_pixel_control_16x16.xls"
%   3.  in 2nd column, remove the last char (,) from the string
%   4.  copy strings to Virtuoso i/o lables for pixel:
%       (tg, rst, sf_bias, rs, out, SO) 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Pixel Input + pixel_Secondary_Output(for Feedback) Wiring instructions:

%   1.  open output excel file "WBCAPD_input_edge_detection_label_names.xls"
%   2.  in 2nd column, remove the last char (,) from the string
%   3.  copy strings to Virtuoso i/o lables for pixel input (A. first 4 rows) + WBCAPD input(B. 2nd 4 rows):
%       (A. PIXEL INPUTS (from WBCAPD and corners)  - connect to pixel TL,TR,BL,BR input nodes) 

%       (B. FOR FEEDBACK    -   WBCAPD WEIGHT INPUTS  , (connect to WBCAPD TL,TR,BL,BR input nodes ) 

%                           1. set WBCAPD Array Dimension: (mxn)
                                            m=15;
                                            n=15;
%                           Pixel Array Dimensions (m+1 x n+1) = 16x16


% 
% TL - Top Left i/o
% TR - Top Right i/o
% BL - Bottom Left i/o
% BR - Bottom Right i/o

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wbcapd_arr = cell(m,n);
for i = 1:m
    for j = 1:n
        wbcapd_arr{i,j} = zeros(2,4); % 4 modulation + 4 colletcion
    end
end
% connectivity
k = 0;
for i = 1:m
    for j = 1:n
        wbcapd_arr{i,j} = {strcat('SO<',int2str(n*(i-1)+(j-1)+k),'>')...    %wbcapd TL modulation to adjecent pixel SO
                           strcat('SO<',int2str(n*(i-1)+(j)+k),'>')...      %wbcapd TR modulation to adjecent pixel SO
                           strcat('SO<',int2str(n*(i)+(j)+k),'>')...        %wbcapd BL modulation to adjecent pixel SO
                           strcat('SO<',int2str(n*(i)+(j+1)+k),'>');        %wbcapd BR modulation to adjecent pixel SO
                           
                           % TBE
                           'v_in<0>'...   %wbcapd TL collection to adjecent pixel BR Storage Well
                           'v_in<1>'...   %wbcapd TR collection to  adjecentpixel  BL Storage Well
                           'v_in<2>'...   %wbcapd BL collection to adjecent pixel TR Storage Well
                           'v_in<3>'...   %wbcapd BR collection to adjecent pixel TL Storage Well
                           }; 
    end
    k = k +1 ;
end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %                                 4-Input-Pixel array initialization & connectivity 

m = m+1; %pixel rows
n = n+1; %pixel columns
% 4 Storage-Well inputs + SO
% TL-1, TR-2, BL-3, BR-4, SO-5
pix_arr = cell(m,n);
for i=1:m
    for j=1:n
        pix_arr{i,j}=zeros(1,5);   
    end
end
%corner connectivity 
pix_arr{1,1} = {'NC','NC','NC','v_out_TL<0>','SO<0>'};
pix_arr{1,n} = {'NC','NC',strcat('v_out_TR<',int2str(n-2),'>'),'NC', strcat('SO<',int2str(n),'>')};
pix_arr{m,1} = {'NC',strcat('v_out_BL<',int2str((m-3)*n+2),'>'),'NC','NC', strcat('SO<',int2str(n*(m-1)),'>')};
pix_arr{m,n} = {strcat('v_out_BR<',int2str((m-1)*(n-1) - 1),'>'),'NC','NC','NC', strcat('SO<',int2str((m*n)-1),'>')};  


%top edge connectivity 
for i=2:n-1
   pix_arr{1,i} = {'NC','NC',...
       strcat('v_out_TR<',int2str(i-2),'>'),...
       strcat('v_out_TL<',int2str(i-1),'>'),...
       strcat('SO<',int2str(i-2),'>')}; % 4 storage-well inputs+ SO  in each pixel
end



%bottom edge connectivity
for i = 2:n-1
    pix_arr{n,i} = {strcat('v_out_BR<',int2str((m-2)*(n-1)+i-2),'>'),...
        strcat('v_out_BL<',int2str((m-2)*(n-1)+i-1),'>'),...
        'NC', 'NC',...
        strcat('SO<',int2str((m-1)*n+1),'>')};
end
%left edge connectivity 
for i= 2 : m-1
    pix_arr{i,1} = {'NC',...
        strcat('v_out_BL<',int2str((i-2)*(n-1)),'>'),...
        'NC',...
        strcat('v_out_TL<',int2str((i-1)*(n-1)),'>'),...
        strcat('SO<',int2str((i-1)*n),'>')};
end
%right edge connectivity
k=1;
for i= 2 : m-1
    pix_arr{i,n} = {strcat('v_out_BR<',int2str((i-1)*(n-2)+k-1),'>'),...
        'NC',...
        strcat('v_out_TR<',int2str((i)*(n-2)+k),'>'),...
        'NC',...
        strcat('SO<',int2str(i*n-1),'>')};
    k=k+1;
end
%middle connectivity
for i = 2:m-1
    for j = 2:n-1
        pix_arr{i,j} = {strcat('v_out_BR<',int2str((i-2)*(n-1)+(j-2)),'>'),...
            strcat('v_out_BL<',int2str((i-2)*(n-1)+(j-1)),'>'),...
            strcat('v_out_TR<',int2str((i-1)*(n-1)+(j-2)),'>'),...
            strcat('v_out_TL<',int2str((i-1)*(n-1)+(j-1)),'>'),...
            strcat('SO<',int2str(n*(i-1)+j-1),'>')};
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

% PIXEL input (output from WBCAPD) connectivity strings
pixel_connectivity_string = cell(4,1); 
    for i = 1:m
        for j=1:n
            pixel_connectivity_string{1,1} = strcat(pixel_connectivity_string{1,1},pix_arr{i,j}(1)) ;   %TL
            pixel_connectivity_string{1,1} = strcat(pixel_connectivity_string{1,1},',');                %TL

            pixel_connectivity_string{2,1} = strcat(pixel_connectivity_string{2,1},pix_arr{i,j}(2)) ;   %TR
            pixel_connectivity_string{2,1} = strcat(pixel_connectivity_string{2,1},',');                %TR

            pixel_connectivity_string{3,1} = strcat(pixel_connectivity_string{3,1},pix_arr{i,j}(3)) ;   %BL
            pixel_connectivity_string{3,1} = strcat(pixel_connectivity_string{3,1},',');                %BL

            pixel_connectivity_string{4,1} = strcat(pixel_connectivity_string{4,1},pix_arr{i,j}(4)) ;   %BR
            pixel_connectivity_string{4,1} = strcat(pixel_connectivity_string{4,1},',');                %BR 
        
        end
    end


% WBCAPD input (output from PIXEL SO [for FEEDBACK ])  Connectivity Strings
m=m-1;
n=n-1;
wbcapd_connectivity_string = cell(4,1);
    for i = 1:m
        for j=1:n
            wbcapd_connectivity_string{1,1} = strcat( wbcapd_connectivity_string{1,1},wbcapd_arr{i,j}{1,1},','); % TL   
            wbcapd_connectivity_string{2,1} = strcat( wbcapd_connectivity_string{2,1},wbcapd_arr{i,j}{1,2},','); % TR  
            wbcapd_connectivity_string{3,1} = strcat( wbcapd_connectivity_string{3,1},wbcapd_arr{i,j}{1,3},','); % BL
            wbcapd_connectivity_string{4,1} = strcat( wbcapd_connectivity_string{4,1},wbcapd_arr{i,j}{1,4},','); % BR
        end
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
 connections = cell(2,1);
 connections {1,1} = pixel_connectivity_string;     %cell {1,1} - pixel input strings (TL,TR,BL,BR)
 connections {2,1} = wbcapd_connectivity_string;    %cell {2,1} - wbcapd input strings (TL,TR,BL,BR)
 pix_in = strings (4,1);
 pix_in(1,1) = connections{1,1}{1,1}(1);
 pix_in(2,1) = connections{1,1}{2,1}(1);
 pix_in(3,1) = connections{1,1}{3,1}(1);
 pix_in(4,1) = connections{1,1}{4,1}(1);

 wbcapd_in = strings (4,1);
 wbcapd_in(1,1) = connections{2,1}{1,1};
 wbcapd_in(2,1) = connections{2,1}{2,1};
 wbcapd_in(3,1) = connections{2,1}{3,1};
 wbcapd_in(4,1) = connections{2,1}{4,1};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%               Virtuoso Labels (remove: " ' " in the begining and end or string and " , " at the end of the string)  
 total = [pix_in ; ' ' ; wbcapd_in];
 writematrix(total, 'feedback_pixel_and_wbcapd_input_label_names.xls');
% final file save to edge_detection_label_names.xls

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%                       control signal strings for pixel (remove ',' at the
%                       end of the string)
m=m+1;
n=n+1;

%control strings (pixel inputs)
tg_str = strings(1,m*n);
rst_str = strings(1,m*n);
sf_bias_str = strings(1,m*n);
rs_str = strings(1,m*n);
col_str = strings(1,m*n);
so_sel_str = strings(1, m*n);

%   ROW control signals strings mat
k=0;
for i=1:m
    for j=1:n
        tg_str(1,i+j+k-1) = strcat('tg<',int2str(i-1),'>',',');
        rst_str(1,i+j+k-1) = strcat('rst<',int2str(i-1),'>',',');
        sf_bias_str(1,i+j+k-1) = strcat('sf_bias<',int2str(i-1),'>',',');
        rs_str(1,i+j+k-1) = strcat('rs<',int2str(i-1),'>',',');
        so_sel_str(1,i+j+k-1) = strcat('so_sel<',int2str(i-1),'>',',');
    end
    k=k+n-1;
end

%  COLUMN control signals strings mat (For readout operation)
count =0;
j=1;
for i=1:m*n
        col_str(1,i) = strcat('col<',num2str(j-1),'>',',');
        count = count +1;
        if count==n
            j=0;
            count =0;
        end
        
        j = j+1;
end

% final strings
tg = string;
rst = string;
sf_bias = string;
rs = string;
col = string;
so_sel = string;

for i=1:m*n
    tg = strcat (tg,tg_str(i));
    rst = strcat (rst,rst_str(i));
    sf_bias = strcat (sf_bias,sf_bias_str(i));
    rs = strcat (rs,rs_str(i));
    col = strcat(col, col_str(i));
    so_sel=strcat(so_sel, so_sel_str(i));
end

control = cell(6,2);
control{1,1} = 'tg';
control{2,1} = 'rst';
control{3,1} = 'sf_bias';
control{4,1} = 'rs';
control{5,1} = 'pixel -> out';
control{6,1} = 'so_sel';
control{1,2} = tg;
control{2,2} = rst;
control{3,2} = sf_bias;
control{4,2} = rs;
control{5,2} = col;
control{6,2} = so_sel;
 writecell(control, 'feedback_pixel_control_labels_16x16.xls'); %remove comma at the end of line

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%