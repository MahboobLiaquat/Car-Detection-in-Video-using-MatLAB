function [mu, sigma, mc] = myfitgmdist_D(x, K, maxIters) 

% Get dimensions of the data
[N, D] = size(x);

% Initialize parameters
mc = ones(1, K) / K;
% mu = zeros(K, D);
mu = round(255 * rand(K, D));
sigma = zeros(D,D,K);
for k = 1 : K
    sigma(D, D, k) = 10;
end
lls = zeros(1, maxIters);
ll = 0;
for n = 1 : N
    s = 0;
    for k = 1 : K
        s = s + mc(k) * mvnpdf(x(n, :), mu(k, :), sigma(:, :, k));
    end
    ll = ll + log(s);
end
old_ll = ll;
% E-step
iter = 1;
rnk = zeros(N, K);
while iter <= maxIters 
    for n = 1:N
        for k = 1:K
            denominator = 0;
            for j = 1:K
                denominator = denominator + mc(j) * mvnpdf(x(n, :),mu(j, :), sigma(:, :, j));
            end
            numerator = mc(k) * mvnpdf(x(n ,:),mu(k, :), sigma(:, :, k));
        end 
        rnk(n, k) = numerator / denominator;
    end
    % M-step
    for k = 1 : K
        Nk = 0;
        for n = 1:N
            Nk = Nk + rnk(n, k);
        end
        
        s = 0;
        for n = 1: N
            s = s + rnk(n, k) * x(n, :);
        end
        mu(k) = s / Nk;
        
        s = 0;
        for n = 1 : N
            s = s + rnk(n, k) * (x(n, :)-mu(k))' * (x(n, :)-mu(k));
        end
        sigma(:,:,k) = s / Nk;
        
        mc(k) = Nk/N;
    end
    
    ll = 0;
    for n = 1 : N
        s = 0;
        for k = 1 : K
            s = s + mc(k) * mvnpdf(x(n, :), mu(k, :), sigma(:, :, k));
        end
        ll = ll + log(s);
    end
    if ll > old_ll
        lls(iter) = ll;
        old_ll = ll;
        iter = iter + 1;
    else
        break;
    end    
end


