clc
clear all
close all

T = 20*ones(1,4);

C = [0; -10; -38; -48];
A = [-3.2 1 1 0; 1 -6.4 0 2; 1 0 -4 2; 0 1 1 -4];

for k = 1:1000
    TKM1 = T;
    for i = 1:4
        T(i) = C(i)/A(i,i);
        for j = 1: i-1
            T(i) = T(i) - (A(i,j)/A(i,i))*T(j);
        end
        for j = i+1:4
            T(i) = T(i) - (A(i,j)/A(i,i))*TKM1(j);
        end
    end
    
    for i = 1:4
        diff = T(i) - TKM1(i);
        error(i) = abs(diff);
    end
    error_max = max(error);
    if k > 10 && error_max < 1e-6
        break;
    end
end

x = [0 0 1 1];
y = [1 0 1 0];

[X,Y] = meshgrid(x,y);

v = griddata(x,y,T,X,Y);

figure
mesh(X,Y,v);
hold on
plot3(x,y,T);