%{
    Finite volume solver for wave propagation and run-up
    Copyright (C) 2018 Denys DUTYKH & Laurent GOSSE

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

%}

%%% ------------------------------------------------------- %%%
%%% Numerical simulation of Feller's equation with adaptive %%%
%%% explicit Lagrangian scheme on a half-real line R^+      %%%
%%% ------------------------------------------------------- %%%
%%% Authors: Denys Dutykh, INSMI-CNRS, LAMA UMR 5127        %%%
%%%          University Savoie Mont Blanc, France           %%%
%%%          Laurent Gosse, IAC-Rome, CNR, Italy            %%%
%%% ------------------------------------------------------- %%%

clear
close all
format longE

addpath progress/

global e2 g N P

%%% Physical parameters:
g  = 0.5;   % gamma: drift coefficient
e  = 1.0;   % eta  : diffusion coefficient
e2 = 2.0*e; % 2*eta

%%% Numerical parameters:
N = 200;    % the number of discretization points

%%% Initial condition specification:
X = logspace(0.0, log10(20.0 + 1.0), N) - 1.0;

q   = 2.0; s = 1.0; a = 3.0;
aux = q + s*exp(a/s);
P = (aux - q*exp(-X/q) - s*exp(-(X - a)/s))/aux;
P = P.';

p0 = (exp(-X/q) + exp(-(X - a)/s))/aux;
X0 = X;

t0 = 0.0;   % simulation start
Y0 = X;     % initial condition
Tf = 12.0;  % final simulation time

% We prescribe various tolerances:
options = odeset('RelTol', 1e-5, 'AbsTol', 1e-5, 'OutputFcn', @odetpbar);
[T Y] = ode45(@FellerRHS, [t0 Tf], Y0, options);
% reconstruct the physical variable:
X = exp(-g*repmat(T, 1, N)).*Y;

%%% We plot the results:
FigHandle = figure(1);
set(FigHandle, 'Renderer', 'zbuffer');

Nt = length(T);
for j=1:50:Nt
    p = [diff(P)./diff(X(j,:).'); 0.0];
    plot(X(j,:), p, '.'), grid off
    xlim([0 30]); ylim([-0.01 1.01]);
    xlabel('$x$', 'interpreter', 'latex', 'fontsize', 12);
    ylabel('$p(x,t)$', 'interpreter', 'latex', 'fontsize', 12);
    title(['Numerical solution at t = ', num2str(T(j), '%3.2f')]);
    set(gcf, 'color', 'w');
    drawnow;
end % for j