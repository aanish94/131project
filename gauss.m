clc
clear all
close all

%Number of nodes (increase to 16 later)
n = 4;
allowable_error = 1e-4;
%This is an arbitrary guess for what T is. 
T = 1*ones(1,n);
T_error = 1*ones(1,n);
%Matrix values taken from example problem in class. 
%Fill in using equations
C = [0; -10; -38; -48];
A = [-3.2 1 1 0; 1 -6.4 0 2; 1 0 -4 2; 0 1 1 -4];

% A*T = C and we need to solve for T
% T = (A^-1)*C and use Gauss Seidel

%Outer iterator
for k = 1:5000 %arbitrarly large number
    T_old = T;
    for i = 1:n %iterating through
        %3 parts to summation
        %Part 1
        T(i) = C(i)/A(i,i);
        %Part 2
        for j = 1:i-1
            T(i) = T(i) - (A(i,j)/A(i,i))*T(j);
        end
        %Part 3
        for j = i+1:n
            T(i) = T(i) - (A(i,j)/A(i,i))*T_old(j);
        end
    end
    %Ensuring value has converged to the correct value
    for i = 1:n
        difference = T(i) - T_old(i);
        T_error(i) = abs(difference);
    end
    max_error = max(T_error);
    %If so, we have found the answer
    if k > 100 && max_error < allowable_error
        break;
    end
end
%Printing out results
count = 1;
for t=T
    fprintf('Temperature at %0d = %5.2f\n',count,t)
    count = count + 1;
end
%Creating surface plots
x = [0 0 1 1];
y = [1 0 1 0];

[X,Y] = meshgrid(x,y);

v = griddata(x,y,T,X,Y);

figure
mesh(X,Y,v);
hold on
plot3(x,y,T);