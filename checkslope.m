function out = checkslope(in)
l = 1;
c = 20;
while abs(abs(in)-l*c)>=0.001
    l = l+1;
end
out = l;
