% Dr. Denys Dutykh (Mathematics Department, Khalifa University of Science and Technology, Abu Dhabi, UAE)
%
% Data of the figure of the README: the run of sources/runFeller.m, repeated line by line
% (drift g = 0.5, diffusion e = 1, N = 200 nodes, the same initial distribution, ode45
% with RelTol = AbsTol = 1e-5 up to t = 12), without the progress bar and the plots,
% which do not change the solution. It keeps about 400 of the output times T of ode45,
% the node positions X(T) at these times and the cumulative probabilities P carried by
% the nodes.
%
% Run it from this folder with MATLAB or GNU Octave:
%   matlab -batch feller_readme_data        or        octave --no-gui feller_readme_data.m
% It writes feller_nodes.mat beside itself (about 0.6 MB); plot_readme_figure.py then draws
% feller-confining.png from it.

here = fileparts(mfilename('fullpath'));
addpath(fullfile(here, '..', '..', 'sources'));

global e2 g N P

%%% Physical parameters (as in runFeller.m):
g  = 0.5;   % gamma: drift coefficient
e  = 1.0;   % eta  : diffusion coefficient
e2 = 2.0*e; % 2*eta

%%% Numerical parameters (as in runFeller.m):
N = 200;    % the number of discretization points

%%% Initial condition (as in runFeller.m):
X = logspace(0.0, log10(20.0 + 1.0), N) - 1.0;

q   = 2.0; s = 1.0; a = 3.0;
aux = q + s*exp(a/s);
P = (aux - q*exp(-X/q) - s*exp(-(X - a)/s))/aux;
P = P.';

p0 = (exp(-X/q) + exp(-(X - a)/s))/aux;
X0 = X;

t0 = 0.0; Y0 = X; Tf = 12.0;

%%% Time integration (as in runFeller.m, without the progress bar):
clock0 = tic;
options = odeset('RelTol', 1e-5, 'AbsTol', 1e-5);
[T, Y] = ode45(@FellerRHS, [t0 Tf], Y0, options);
runtime = toc(clock0);
% reconstruct the physical variable:
X = exp(-g*repmat(T, 1, N)).*Y;
noutputs = numel(T);

%%% About 400 of the output times are kept, the last one included:
stride = ceil(numel(T)/400);
kept = unique([1:stride:numel(T), numel(T)]);
T = T(kept); X = X(kept, :);

if exist('OCTAVE_VERSION', 'builtin') ~= 0
  engine = ['GNU Octave ' OCTAVE_VERSION];
else
  engine = ['MATLAB ' version];
end
save(fullfile(here, 'feller_nodes.mat'), 'T', 'X', 'P', 'X0', 'p0', 'g', 'e', 'N', 'noutputs', ...
     'runtime', 'engine', '-v7');
fprintf('%d output times of ode45 up to t = %g in %.1f s (%s); largest node x = %.6g at t = 0 and %.6g at the end\n', ...
        noutputs, T(end), runtime, engine, max(X(1, :)), max(X(end, :)));
