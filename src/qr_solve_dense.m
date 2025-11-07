function x = qr_solve_dense(A,b)
% QR_SOLVE_DENSE  Solve min ||A*x - b||_2 using explicit Householder QR.
%   No backslash, pinv, chol, svd, regress, fitlm, arima, etc.
    [m,n] = size(A); R = A; y = b; %#ok<ASGLU>
    for k = 1:n
        % Find column of R to reflect down to a multiple of e_1
        % (zero out all but first entry)
        v = R(k:end,k);

        % Find the reflection vector 
        % v_reflection = v + sign(v(1)) * norm(v) * e_1
        alpha = -sign(v(1)) * norm(v);
        v(1) = v(1) - alpha;             
        v = v / norm(v);

        % Implicitly apply the Q_k reflection to R and y at row k and below.
        R(k:end,k:end) = R(k:end,k:end) - 2*v*(v.'*R(k:end,k:end));
        y(k:end)       = y(k:end)       - 2*v*(v.'*y(k:end));
    end

    % Solve R_1 x = Q_1^T b using back-substitution,
    % where R_1 is the nxn upper triangular 
    % submatrix of R, and Q_1 is the corresponding left mxn submatrix
    % of Q (this has already implicitly been applied to b to form y)
    R = triu(R(1:n,1:n)); x = zeros(n,1);
    for i = n:-1:1
        x(i) = (y(i) - R(i,i+1:end)*x(i+1:end)) / R(i,i);
    end
end
