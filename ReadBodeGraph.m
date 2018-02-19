%clear all;
%clc;

% k     = openfig('Bode122.fig'); hold on;
function tranFunc = ReadBodeGraph(figIn)
h     = findobj(figIn,'type','line');
xdata = get(h,'Xdata');
ydata = get(h,'Ydata');

M     = length(xdata);
q     = 1;
flag  = 1;
m     = 1; 
s =tf('s');
tf1    = 1;
j = 1;
for n=2:M
    if xdata(n-1)~=xdata(n);
     deltX(n)  = log10(xdata(n))-log10(xdata(n-1));
     deltY(n)  = ydata(n)-ydata(n-1);
     diffY(j)  = deltY(n)/deltX(n); 
     freq(j) = xdata(n);
     j = j+1;
    end   
end
ch_slope = zeros(1,length(diffY));
for n = 2:length(diffY)
    ch_slope(n) = diffY(n)-diffY(n-1);
end
for n = 2:length(diffY)
         if(ch_slope(n)>0)
             index(n)=checkslope(ch_slope(n));
         elseif(ch_slope(n)<0)
             index(n)=checkslope(ch_slope(n));
         end
      if(diffY(n)>0&&index(n)~=0)
         tf1 = tf1*(s+freq(n-1))^index(n)
      elseif(diffY(n)<0&&index(n)~=0)
         tf1 = tf1/(s+freq(n-1))^index(n)
      end 
end
dc_value = dcgain(tf1);
K = 10^(ydata(1)/20)/dc_value;
tranFunc = K*tf1