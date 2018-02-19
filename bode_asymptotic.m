function bode_as(num,den)

zroots=roots(num);
proots=roots(den);
[iz,jz]=find(abs(zroots)==0); 
numz=length(iz);
[ip,jp]=find(abs(proots)==0); 
nump=length(ip);
pend=numz-nump;
sz=[1:length(zroots)];
sp=[1:length(proots)];
zroots=zroots(setdiff(sz,iz),:);
proots=proots(setdiff(sp,ip),:);


zroots2=abs(zroots)-j*real(zroots)./abs(zroots);
proots2=abs(proots)-j*real(proots)./abs(proots);


zz=ones(size(zroots2,1),3);
zz(:,2)=real(zroots2);
zz(:,3)=imag(zroots2);
pp=-ones(size(proots2,1),3);
pp(:,2)=real(proots2);
pp(:,3)=imag(proots2);


%tracciamento moduli
pp_mag=pp;
zz_mag=zz;
vect=[zz_mag;pp_mag];

vect=sortrows(vect,2);
interval=zeros(1,size(vect,1)+2);
interval(:,[2:(size(vect,1)+1)])=vect(:,2)';
try
interval(1,1)=0.01*vect(1,2);
interval(1,end)=100*vect(end,2);
catch
interval(1,1)=0.01*1;
interval(1,2)=100*1;
end

[g,p]=bode(num,den,interval(1));grid on

y(1)=20*log10(g);
indice=2;
y_old=y(1);
i_old=interval(1);
for i=interval(:,[2:length(interval)-1])
    y(indice)=20*pend*log10(i)+y_old-20*pend*log10(i_old);
    pend=pend+vect(indice-1,1);
    i_old=i;
    y_old=y(indice);
    indice=indice+1;
end
y(indice)=20*pend*log10(interval(end))+y_old-20*pend*log10(i_old);
semilogx(interval,y,'r');
grid on
