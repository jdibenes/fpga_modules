
clear all

sigma = 2;
Q = 7;

f_m   = fopen('median_out.bin');
f_out = fopen('dg_out.bin');

m  = fread(f_m,   [1, 3840], 'uint8');
dg = fread(f_out, [1, 3840], 'int16');

% imp_dgfilter(sigma) .* (2^Q);
fdg = [7 23 57 103 128 93 0 -93 -128 -103 -57 -23 -7]; 
im_dg = floor(imp_convolution1D(m, fdg) / (2^Q));

valid_dg    = dg((1 + 2*6):end);
valid_im_dg = im_dg((1 + 6):(end - 6));

error = abs(valid_im_dg - valid_dg);

disp(['max error: ' num2str(max(error))]);
