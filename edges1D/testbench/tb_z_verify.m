
clear all

Q = 11;

f_dg    = fopen('dg_out.bin');
f_edges = fopen('edges_out.bin');

dg = fread(f_dg,   [1, 3840], 'int16');

% matlab 1-indexing + valid dg filter - median filter shift
valid_dg = dg((1 + 2*4 - 1):end); 

edges_sim = fread(f_edges, Inf, 'int32') / (2^Q);

edges_mat = imp_edgesdg_fsm(valid_dg, 76);
edges_mat = edges_mat - 1; % to 0-indexing

error = abs(edges_sim(:) - edges_mat(:));
disp(['max error: ' num2str(max(error))]);
