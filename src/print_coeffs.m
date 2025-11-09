function print_coeffs(coefs)
% PRINT_COEFFS  Displays model coefficients, separating
% out each type of coefficient and indexing appropriately
%
% Parameters:
%       coefs = struct of unpacked coefficients for best fit
%               difference eqauation. Has fields:
%                   .c: Scalar; constant term
%                   .d: Scalar; coefficient of time index 
%                   .a: Length N vector; coefficients of lag
%                   .alpha: Length K vector; coefficients of cosine
%                           seasonal harmonics
%                   .beta: Length K vector; coefficients of sine
%                          seasonal harmonics
    fprintf('\n------ FITTED DIFFERENCE EQUTION COEFFICIENTS ------\n')
    % Parse coefficients 
    c = coefs.c;
    d = coefs.d;
    a_coefs = coefs.a;
    alpha_coefs = coefs.alpha;
    beta_coefs = coefs.beta;

    % Display scalar coefficients
    fprintf('-- LINEAR COMPONENT COEFFICIENTS --\n')
    fprintf('c = %.5f\n', c);
    fprintf('d = %.5f\n', d);

    % Display lag coefficients
    fprintf('\n-- LAG COMPONENT COEFFICIENTS --\n')
    if numel(a_coefs) == 0 
        fprintf('No a_k coefficients (N = 0)\n')
    else 
        for i=1:numel(a_coefs)
            fprintf('a_%d = %.5f\n', i, a_coefs(i));
        end
    end

    % Display seasonal harmonic coefficients 
    fprintf('\n-- SEASONAL TRIGONOMETRIC COMPONENT COEFFICIENTS --\n')
    if numel(alpha_coefs) == 0
        fprintf('No alpha_k/beta_k coefficients (K = 0)\n')
    else 
        for i=1:numel(alpha_coefs)
            fprintf('alpha_%d = %.5f\n', i, alpha_coefs(i));
        end
        for i=1:numel(beta_coefs)
            fprintf('beta_%d = %.5f\n', i, beta_coefs(i));
        end
    end
    fprintf('\n')
end