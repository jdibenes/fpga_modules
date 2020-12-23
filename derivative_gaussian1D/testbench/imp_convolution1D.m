
function out = imp_convolution1D(line, filter)
half = fix(numel(filter) /  2);
width = numel(line);
out = zeros(1, width);
for x = (1 + half):(width - half), out(x) = sum(line(x + (-half:half)) .* filter); end
end
