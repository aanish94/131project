clc
clear all
close all

%ALUMINUM
k_cond = 230;
%STAINLESS STEEL
% k = 15.1;
h = 10;
Tinf = 50+273;
Ta = 100+273;
Tb = 200+273;
delta_x = 0.1;
delta_y = 0.1;
Bi = h*delta_x/k_cond;

%Number of nodes (increase to 16 later)
n = 16;
%arbitrary
allowable_error = 1e-6;
%This is an arbitrary guess for what T is.
T = 1*ones(1,n);
T_error = 1*ones(1,n);
%Fill in using equations
%Rearranged equations and converted to matrix. Values in terms of Biot
%number so can change k later
A = zeros(n,n);
C = zeros(n,1);

%Equation 1
A(1,1) = -2*(Bi+2);
A(1,2) = 2;
A(1,5) = 1;
C(1) = -2*Bi*Tinf-Ta;

%Equation 2
A(2,1) = 1;
A(2,2) = -4;
A(2,3) = 1;
A(2,6) = 1;
C(2) = -Ta;

%Equation 3
A(3,2) = 1;
A(3,3) = -4;
A(3,4) = 1;
A(3,7) = 1;
C(3) = -Ta;

%Equation 4
A(4,3) = 1;
A(4,4) = -4;
A(4,8) = 1;
C(4) = -1*(Ta+Tb);

%Equation 5
A(5,1) = 1;
A(5,5) = -2*(Bi+2);
A(5,6) = 2;
A(5,9) = 1;
C(5) = -2*Bi*Tinf;

%Equation 6
A(6,2) = 1;
A(6,5) = 1;
A(6,6) = -4;
A(6,7) = 1;
A(6,10) = 1;

%Equation 7
A(7,3) = 1;
A(7,6) = 1;
A(7,7) = -4;
A(7,8) = 1;
A(7,11) = 1;

%Equation 8
A(8,4) = 1;
A(8,7) = 1;
A(8,8) = -4;
A(8,12) = 1;
C(8) = -Tb;

%Equation 9
A(9,5) = 1;
A(9,9) = -2*(Bi+2);
A(9,10) = 2;
A(9,13) = 1;
C(9) = -2*Bi*Tinf;

%Equation 10
A(10,6) = 1;
A(10,9) = 1;
A(10,10) = -4;
A(10,11) = 1;
A(10,14) = 1;

%Equation 11
A(11,7) = 1;
A(11,10) = 1;
A(11,11) = -4;
A(11,12) = 1;
A(11,15) = 1;

%Equation 12
A(12,8) = 1;
A(12,11) = 1;
A(12,12) = -4;
A(12,16) = 1;
C(12) = -Tb;

%Equation 13
A(13,9) = 1;
A(13,13) = -1*(2+Bi);
A(13,14) = 1;
C(13) = -1*Bi*Tinf;

%Equation 14
A(14,10) = 2;
A(14,13) = 1;
A(14,14) = -4;
A(14,15) = 1;

%Equation 15
A(15,11) = 2;
A(15,14) = 1;
A(15,15) = -4;
A(15,16) = 1;

%Equation 16
A(16,12) = 2;
A(16,15) = 1;
A(16,16) = -4;
C(16) = -Tb;

%USE THIS TO CHECK AND VALIDATE ANSWER
T_actual = A\C;
% A*T = C and we need to solve for T
% T = (A^-1)*C and use Gauss Seidel

%Outer iterator
for k = 1:1000 %arbitrarly large number
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
    if k > 10 && max_error < allowable_error
        break;
    end
end
%Printing out results
count = 1;
for t=T
    fprintf('Temperature at %0d = %5.3f\n',count,t)
    count = count + 1;
end

