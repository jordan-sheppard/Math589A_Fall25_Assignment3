function S = score_model(RSS, M, p, criterion)
% SCORE_MODEL  Scores a model's performance.
%
%   RSS = scalar; The RSS error of the best-fit least-squares
%         solution used to find the model fit 
%   M = scalar; = T - N (the number of entries in the response
%       vector for this model's fitting process 
%   p = scalar; = 2K + N + 2 (the number of coefficients/terms
%       in this model's final difference equation)
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
%   S = scalar; the resulting AIC/BIC score, depending on the
%       specified scoring criterion.
%

    % If no criterion provided, default to BIC
    if nargin<4 || isempty(criterion), criterion = 'bic'; end

    % BIC Scoring
    if strcmpi(criterion,'bic')
        S = M*log(RSS/M) + p*log(M);
    % AIC Scoring
    else
        S = M*log(RSS/M) + 2*p;
    end
end
