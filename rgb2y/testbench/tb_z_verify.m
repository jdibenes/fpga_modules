
clear all

f_r   = fopen('row_r_1060.bin');
f_g   = fopen('row_g_1060.bin');
f_b   = fopen('row_b_1060.bin');
f_out = fopen('rgb2y_out.bin');

R = uint8(fread(f_r,   [1, 3840], 'uint8'));
G = uint8(fread(f_g,   [1, 3840], 'uint8'));
B = uint8(fread(f_b,   [1, 3840], 'uint8'));
Y = uint8(fread(f_out, [1, 3840], 'uint8'));

im_gray = rgb2gray(cat(3, R, G, B));

error = abs(double(im_gray) - double(Y));

disp(['max error: ' num2str(max(error))]);
