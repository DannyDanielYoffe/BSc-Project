
is_voltage_raw = readmatrix ('is_results.csv'); %impoted file from Virtuoso
is_voltage(:,:) = is_voltage_raw(:,2:17); %removes "cycle" column
min_val = min(is_voltage(:));
is_voltage = is_voltage - min_val;
max_val = max(is_voltage(:));
is_voltage = ((is_voltage)*255);
is_voltage = is_voltage/max_val;

fb_voltage_raw = readmatrix ('fb_results.csv'); %impoted file from Virtuoso
fb_voltage(:,:) = fb_voltage_raw(:,2:17); %removes "cycle" column
min_val = min(fb_voltage(:));
fb_voltage = fb_voltage - min_val;
max_val = max(fb_voltage(:));
fb_voltage = ((fb_voltage)*255);
fb_voltage = fb_voltage/max_val;

edge_mat = fb_voltage - is_voltage;
image(edge_mat);