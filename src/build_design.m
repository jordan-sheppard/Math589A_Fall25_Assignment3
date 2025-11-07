function [A,b,meta] = build_design(y, s, N, K)
% BUILD_DESIGN  Construct LS system for N-th order difference eq + K harmonics.
%   y : Tx1 double (column)
%   s : scalar season (e.g., 12)
%   N : nonnegative integer (order of past)
%   K : nonnegative integer (# harmonics)
% Returns:
%   A : (T-N)x(1+N+2K) matrix  [1, lags..., cos..., sin...]
%   b : (T-N)x1 vector         [y_{N+1: T}]
%   meta : struct with fields: .rows=M, .p=p, .t=(N+1:T).'
%
    y = y(:); T = numel(y);
    M = T - N;          % Number of time periods in response vector
    p = 2 + N + 2*K;    % Number of terms in time series linear equation 
    if M < p
        error('Underdetermined: T-N (= %d) must be >= 2K+N+2 (= %d).', M, p);
    end
    b = y(N+1:T);
    t = (N+1:T).';
    A = ones(M, p);

    % First column: all ones
    % Second column: t's
    A(:,2) = t;

    % lag columns: 3 through 3+(N-1) = N+2
    col = 2;
    for i = 1:N
        col = col + 1;
        A(:, col) = y(N+1-i : T-i);
    end
    
    % cosine columns: N+3 through N+3+(K-1)=N+K+2
    for k = 1:K
        col = col + 1;
        A(:, col) = cos(2*pi*k*t/s);
    end
    % sine columns: N+K+3 through N+K+3+(K-1) = N+2K+2 = p
    for k = 1:K
        col = col + 1;
        A(:, col) = sin(2*pi*k*t/s);
    end
    meta = struct('rows',M,'p',p,'t',t);
end
