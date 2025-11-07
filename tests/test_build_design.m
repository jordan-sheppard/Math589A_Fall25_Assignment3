addpath(fullfile('..','src'));
y = (1:20)'; s=12; N=3; K=2;
[A,b,meta] = build_design(y,s,N,K);
assert(size(A,1)==20-3 && size(A,2)==2+3+2*2);  % CHANGED TO ADD LINEAR TERM!
assert(all(b(1:3)==y(4:6)));
disp('build_design OK');
