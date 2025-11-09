function best = select_model(y, s, Ngrid, Kgrid, criterion)
% SELECT_MODEL  Performs a grid search to select the best time
% series seasonal difference equation model 
% y_t = c + dt + \sum_{i=1}^{N}a_i y_{t-i} 
%          + \sum_{k=1}^{K}[\alpha_k \cos(2\pi k t/s)]
%          + \sum_{k=1}^{K}[\beta_k  \sin(2\pi k t/s)].
% Grid search is performed over the following hyperparameters:
%     -> N (the number of lag parameters to use)
%     -> K (the number of seasonal harmonics to use)
%
% Parameters:
%   y = length T vector; scalar time series data to fit 
%   s = scalar; period of season in terms of number of timesteps
%   Ngrid = 1D vector of nonnegative integers; Values of N to 
%           search over 
%   Kgrid = 1D vector of nonnegative integers; Values of K to
%           search over 
%   criterion = string; which scoring criterion to use.
%               Currently accepted criteria:
%                   'bic' : Bayesian Information Criterion:
%                           M log(RSS/M) + p log(M)
%                           (This is the default if no criterion is
%                           provided)
%                   All other strings: Akaike Information Criterion:
%                           M log(RSS/M) + 2p)
%
% Returns:
%   best = struct; the resulting best model, with fields:
%       .score = scalar; the model's score
%       .criterion = string; the model's scoring criterion
%                    (AIC or BIC)
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
%       .all_scores = size(Ngrid,Kgrid) vector; the scores of each 
%                     candidate model (not just the current best)
%                     at each gridpoint N, K.
%
best = struct('score', Inf);
all_scores = zeros([numel(Ngrid), numel(Kgrid)]);
i = 1;
for N = Ngrid(:).'
  j = 1;
  for K = Kgrid(:).'
    try
      fit = fit_once(y, s, N, K);
    catch
      continue
    end
    S = score_model(fit.RSS, fit.M, fit.p, criterion);
    all_scores(i,j) = S;
    if S < best.score
        best = fit; best.score = S; best.criterion = criterion;
    end
    j = j + 1;
  end
  i = i + 1;
end
best.all_scores = all_scores;
end
