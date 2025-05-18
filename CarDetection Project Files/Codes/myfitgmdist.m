function [mu, sigma, mc] = myfitgmdist(x, K, maxIters) 

% Get dimensions of the data
[N, D] = size(x);% for 1D, d is 1 and N is number of pixel intensities(1-256)

% Initialize parameters
mc = ones(1, K) / K;%1xK matrix
% mu = zeros(K, D);%KxD matrix
mu = round(255 * rand(K, D));%means are randomly initialized between 0 and 255
sigma = zeros(D,D,K);%DxDxK matrix
for k = 1 : K
    sigma(D, D, k) = 10;%all initially 10
end
lls = zeros(1, maxIters);%vector, stores the log-likelihood values for each iteration
ll = 0;%log-likelihood initially 0
for n = 1 : N
    s = 0;
    for k = 1 : K
        s = s + mc(k) * normpdf(x(n, :), mu(k, :), sigma(:, :, k));
        %above, this is only likelihood & should increase with each iteration
    end
    ll = ll + log(s); %Until here is Step 1 completed
end
old_ll = ll;%Save the initial ll to compare later with new ll for convergence criterion
% E-step
iter = 1;
rnk = zeros(N, K);
while iter <= maxIters 
    for n = 1:N
        for k = 1:K
            denominator = 0;
            for j = 1:K
                denominator = denominator + mc(j) * normpdf(x(n, :),mu(j, :), sigma(:, :, j));
            end
            numerator = mc(k) * normpdf(x(n ,:),mu(k, :), sigma(:, :, k));
        end 
        rnk(n, k) = numerator / denominator; %probability that the 'kth' mc/gaussian
                                      % generated 'nth' pixel intensity                                 
    end
    %Next is step-3
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
    %Step-4, to again calculate log-likelihood and check for convergence of
    %parameters/log-likelihood, else return to step-2 
    ll = 0;
    for n = 1 : N
        s = 0;
        for k = 1 : K
            s = s + mc(k) * normpdf(x(n, :), mu(k, :), sigma(:, :, k));
        end
        ll = ll + log(s);
    end
    if ll > old_ll
        lls(iter) = ll;%ll is stored in vector lls of index 'iter'
        old_ll = ll;
        iter = iter + 1;%iteration increment done, so that next time when ll is 
        %again calculated, it can be stored in lls(iter) for comparison
        %later
    else
        break;% if convergence criterion is achieved
    end  
end


