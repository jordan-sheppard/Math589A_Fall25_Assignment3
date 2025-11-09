% scripts/run_tucson.m
addpath(fullfile('..','src'));

% Read in monthly Tucson Electricity Data
tbl = readtable('../data/tucsonAZ.csv');
y = tbl.elecuse;
T = numel(y);       % Number of timesteps
t = 1:T;

% Set model search parameters 
s = 12;             % Seasons should last 12 months
Ngrid = 0:8;        % Lag component grid
Kgrid = 0:8;        % Seasonal harmonic grid    
criterion = 'bic';  % Model Scoring Criterion: BIC 

% Search for best model
best = select_model(y, s, Ngrid, Kgrid, criterion);
N_best = best.N;
K_best = best.K;
M_best = best.M;

% Display best model parameters 
fprintf('================ BEST MODEL PARAMETERS ================\n')
fprintf('N* = %d, K* = %d, Resulting BIC = %.5f\n', N_best, K_best, best.score);

print_coeffs(best.coef);

% Display plot of model scores over search grid 
figure;
[Kmeshgrid, Nmeshgrid] = meshgrid(Kgrid, Ngrid);
surf(Nmeshgrid, Kmeshgrid, best.all_scores);
xlabel('Candidate N Values');
ylabel('Candidate K Values');
zlabel('BIC');
title('Parameter Grid Search over (N,K) - BIC Results');
view(3); % Ensures a 3D view (default for surf)
grid on;


fprintf('============== Model Forecast Performance =============\n')

% Compute in–sample mean–squared prediction error using one-step-ahead prediction
y_response_one_step = predict_in_sample(y, s, best.coef);
y_response_actual = y((T - best.M)+1:end);
in_sample_mse = sum((y_response_actual - y_response_one_step).^2) ./ (T - N_best);
fprintf('In-Sample (One-Step-Ahead Prediction) MSE = %.10f\n\n', in_sample_mse);

% Compute 12-step forecast
num_steps = 12; 
fprintf('%d Step Forecast:\n', num_steps)
yF = forecast(y, s, best.coef, num_steps);
for i = 1:num_steps
    fprintf('  yhat_{T + %d} = %.5f\n', i, yF(i));
end

% Display 12-step forecast in a plot
figure; 
hold on;
plot(t, y, 'k-*');
plot(t, y_response_one_step, 'b-+');
plot(T+1:T+num_steps, yF, 'r-+')
hold off;
legend('Actual Usage', 'Predicted Usage', '12-Month Usage Forecast');
xlabel('Month');
ylabel('Electric Usage');
title('Tucson Electric Usage')