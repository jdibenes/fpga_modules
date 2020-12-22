
function out = imp_median1D(l, n)
width = numel(l);
out = zeros(1, width);
for x = (1 + n):(width - n), out(x) = median(l(x + (-n:n))); end
end
