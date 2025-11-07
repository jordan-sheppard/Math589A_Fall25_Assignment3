function yhat = predict_in_sample(y, s, coef)
% PREDICT_IN_SAMPLE     Given some data y, and a set of coefficients
% describing a model of best fit, try to predict the response 
% vector using a one-step-ahead prediction from the given 
% data vector.
%
% Parameters:
%   y = length T vector; scalar time series data 
%   s = scalar; period of season in terms of number of timesteps
%   coef: struct with fields:
%       .c: Scalar; constant term
%       .d: Scalar; coefficient of time index 
%       .a: Length N vector; coefficients of lag
%       .alpha: Length K vector; coefficients of cosine
%               seasonal harmonics
%       .beta: Length K vector; coefficients of sine
%              seasonal harmonics
%
% Returns:
%   yhat = length M = T - N vector; the predicted response vector
%
y = y(:);               % Time series data
T = numel(y);           % Number of timesteps in data  
N = numel(coef.a);      % Number of lag elements in model
K = numel(coef.alpha);  % Number of seasonal harmonics in model
M = T - N;              % Length of response vector in model

% Create predicted response vector using a one-step-ahead
% prediction from the given data vector at each timestep
yhat = zeros(M,1);
for k = 1:M
    t = N + k; % Actual time index for row k

    % Compute the seasonal component at this timestep
    seasonal = 0;
    for h = 1:K
        seasonal = seasonal + coef.alpha(h)*cos(2*pi*h*t/s) + coef.beta(h)*sin(2*pi*h*t/s);
    end

    % Compute constant/linear component at this timestep
    prediction = coef.c + coef.d * t + seasonal;

    % Compute lag component using one-step-ahead prediction
    % (that is, use only original data, not previous predictions)
    for i = 1:N
        prediction = prediction + coef.a(i)*y(t-i);
    end
    yhat(k) = prediction;
end
end
