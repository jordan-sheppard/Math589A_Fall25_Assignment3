function out = fit_once(y, s, N, K)
% FIT_ONCE  Fits a N-th order difference eq (with K seasonal
% harmonics with period s) to the scalar time-series data y.
%
%   y : Tx1 double (column)
%   s : scalar period of season (e.g., 12)
%   N : nonnegative integer (order of past)
%   K : nonnegative integer (# harmonics)
%
% Returns:
%   out : struct with fields: 
%       .beta = length 2K+N+2 vector; coefficients of best fit
%               difference equation
%       .coef = struct of unpacked coefficients for best fit
%               difference eqauation. Has fields:
%                   .c: Scalar; constant term
%                   .d: Scalar; coefficient of time index 
%                   .a: Length N vector; coefficients of lag
%                   .alpha: Length K vector; coefficients of cosine
%                           seasonal harmonics
%                   .beta: Length K vector; coefficients of sine
%                          seasonal harmonics
%       .RSS = scalar; Residual sum of squares; Size of residual
%              error in least-squares solution/fit
%       .M = scalar; Number of rows in response vector
%       .p = scalar; = 2K+N+2; Number of coefficients in time series
%            linear equation 
%       .N = nonnegative integer; number of lag terms
%       .K = nonnegative integer; number of seasonal harmonics
%       .s = scalar; period of season in terms of number of timesteps
%       .res = length M vector; residual/error of coefficients of
%              best fit
%
    [A,b,meta] = build_design(y, s, N, K);
    beta = qr_solve_dense(A, b);
    res  = A*beta - b;
    RSS  = res.'*res;
    out = struct('beta',beta, 'coef',unpack_coeffs(beta,N,K), ...
                 'RSS',RSS, 'M',meta.rows, 'p',meta.p, ...
                 'N',N, 'K',K, 's',s, 'res',res);
end
