function output_IVP = solve_IVP2(x0, p0,n ,L ,s,params)

% This function solves the IVP at the current value of p0
% Function Inputs:
%   x0 : initial condition for x(0) for every particle (nx3)
%        i th row is x1,x2,x3 position for i th particle
%   p0 : initial condition for p(0) for every particle (nx3)
%        i th row is p1,p2,p3 force for i th particle
%   s : end of rod interval (usually 1),scalar, as "time t"
%   n  : number of particles
%   L  : length of each rod
% Function Outputs:
%   output_IVP.t : tx1 vector of time values along solution, 
%                  a column vector
%   output_IVP.xi : txn vector of xi component for the n particles
%   output_IVP.pi : txn vector of pi component for the n particles


% Initialize v and w

V = eye(6*n);
W = zeros(6*n,n);

% Initial conditions, initialize Y0
Y0 = zeros(1,6*n);

%stores values of x and p in Y0
for i=1:n
    Y0(6*(i-1)+1:6*i) =  [x0(i,:) p0(i,:)];
end


% U input

U0 = [Y0 reshape(V,1,[]) reshape(W,1,[])];

% Solve ODEs by ode45

[t,sol] = ode45(@(t,Y) diff_eqns2(t,Y,n,L,params),[0 s], U0,params.ode_options);

solution = reshape(sol, length(t),[]);

% Store vectors t, x, and p
output_IVP.t = t;

output_IVP.x1 = solution(:,1:6:6*n);
output_IVP.x2 = solution(:,2:6:6*n);
output_IVP.x3 = solution(:,3:6:6*n);

output_IVP.p1 = solution(:,4:6:6*n);
output_IVP.p2 = solution(:,5:6:6*n);
output_IVP.p3 = solution(:,6:6:6*n);

output_IVP.V1 = reshape(solution(end,6*n+1:36*n*n+6*n),6*n,6*n);
output_IVP.W1 = reshape(solution(end,36*n*n+6*n+1:end),6*n, n);

output_IVP.V0 = reshape(solution(1,6*n+1:36*n*n+6*n),6*n,6*n);
output_IVP.W0 = reshape(solution(1,36*n*n+6*n+1:end),6*n, n);

end









