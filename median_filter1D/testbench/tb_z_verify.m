
clear all

f_y   = fopen('rgb2y_out.bin');
f_out = fopen('median_out.bin');

y = uint8(fread(f_y,   [1, 3840], 'uint8'));
m = uint8(fread(f_out, [1, 3840], 'uint8'));

im_m = imp_median1D(y, 1);

valid_m = m(3:end);
valid_im_m = im_m(2:(end-1));

error = abs(double(valid_im_m) - double(valid_m));

disp(['max error: ' num2str(max(error))]);
