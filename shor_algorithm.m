% Designed by Om Joshi and Parth Shroff
% Shor's Algorithm, implemented in Matlab

N = input("N = ");
Q = N^2;
qft = zeros(Q,Q);
for i = 1:Q
    for j = 1:Q
        qft(i,j) = exp(1i*2*pi*(i-1)*(j-1)/Q)/sqrt(Q);
    end
end

while true
    x = input("x = ");
    if gcd(N,x) ~= 1 
        fprintf("Hooray! gcd(N,x) != 1, it's %d which is a factor of %d.\n",gcd(N,x),N);
        return;
    end
    
    
    fr = ones(Q,1)/sqrt(Q);

    fr(1) = x^(1-0);
    for i = 2:Q
        fr(i) = mod(x*fr(i-1),N);
    end

    % fprintf("These are the values of f(r): \n")
    % disp(unique(r.'));
    % f_r = input("Pick one to 'measure': ");
    % fprintf("\n\n\n");
    f_r = 1;

    for i = 1:Q 
        if fr(i) ~= f_r
            fr(i) = 0;
        end
    end

    fr = normalize(fr, 'norm');

    qft_r = qft*fr;
    figure;
    plot(0:Q-1,abs(qft_r).^2);
    xlim([-Q/10 Q+Q/10]);
    title("QFT for N=" + N + " Q = " + Q + " x=" + x);
    xlabel("k");
    ylabel("P(k)");
    [sorted,indices] = sort(qft_r, 'descend');



    top = 20;
    ks = zeros(1,top);
    for i = 1 : top
        if abs(sorted(i)) > 1e-6
            ks(1,i) = (indices(i)-1)/Q;
            % fprintf("state |%d> with probability %f\n", indices(i)-1, abs(sorted(i)).^2);
        end
    end
    [ks,indices] = sort(ks);

    % k = input("above are the top few states and their amplitudes. pick one to 'measure' as 'k': ");
    % fprintf("k/Q = %d/%d = %f\n", k,Q, k/Q);

    fprintf("These are the approximate values of c/s:\n");
    disp(reshape(ks,[2,top/2]));
    s = input("What do you think s is? ");
    if mod(s,2) == 0 && mod(x^(s/2),N) ~= -1
        fprintf("If everything went right, %d = %d x %d\n", N, gcd(N,x^(s/2)-1), gcd(N,x^(s/2)+1));
        return;
    end
    fprintf("You were unlucky! Try again with a different x value!\n");
end
