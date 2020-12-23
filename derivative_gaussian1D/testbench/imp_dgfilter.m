
function f = imp_dgfilter(sigma)
half = ceil(sigma * 3);
x = -half:half;
f = -x .* exp(-(x.^2)/(2*sigma^2));
f = f - (sum(f) / numel(f));
f = f / max(abs(f));
end
