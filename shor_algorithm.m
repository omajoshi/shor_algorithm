% Designed by Om Joshi and Parth Shroff
% Shor's Algorithm, implemented in Matlab

N = input("N = ");
x = input("x = ");
if gcd(N,x) ~= 1 
    fprintf('Hooray! %s is already a factor of %s.\n',x,n);
end
Q = N^2;
qft = zeros(Q,Q);
for i = 1:Q
    for j = 1:Q
        qft(i,j) = exp(1i*2*pi*(i-1)*(j-1)/Q)/sqrt(Q);
    end
end

r = ones(Q,1)/sqrt(Q);

r(1) = x^(1-0);
for i = 2:Q
    r(i) = mod(x*r(i-1),N);
end

fprintf("These are the values of f(r): \n")
disp(unique(r.'));
f_r = input("Pick one to 'measure': ");

for i = 1:Q 
    if r(i) ~= f_r
        r(i) = 0;
    else
        r(i) = 1;
    end
end
    
r = normalize(r, 'norm');
fprintf("\n\n\n");

qft_r = qft*r;
figure;
plot(0:Q-1,abs(qft_r));
xlim([-Q/10 Q+Q/10]);
[sorted,indices] = sort(qft_r, 'descend');

top = 10;
for i = 1 : top
    if sorted(i) > 1e-6
        fprintf("state |%d> with amplitude %f\n", indices(i)-1, abs(sorted(i)));
    end
end

k = input("above are the top few states and their amplitudes. pick one to 'measure' as 'k': ");
fprintf("k/Q = %d/%d = %f\n", k,Q, k/Q);
% add lookup table to match k/Q to c/s, then keep track of s -> lcm({s})