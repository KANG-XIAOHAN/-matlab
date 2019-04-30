
X = A(:,1) ;
X1 = table2array(X);
X2 = mean(reshape(X1,835,round(length(X1)/835)));

Y = A(:,2) ;
Y1 = table2array(Y);
Y2 = mean(reshape(Y1,835,round(length(Y1)/835)));

Z = A(:,3) ;
Z1 = table2array(Z);
Z2 = mean(reshape(Z1,835,round(length(Y1)/835)));


figure;
plot(X2,Y2,'-r');
figure;
plot(X2,Z2,'-d')
figure;


hold on

set(gca,'XTick',[0:8000:500000])
set(gca,'YTick',[6:10:150])


