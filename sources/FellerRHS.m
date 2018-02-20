%%% ------------------------------------------------------- %%%
%%% Authors: Denys Dutykh, INSMI-CNRS, LAMA UMR 5127        %%%
%%%          University Savoie Mont Blanc, France           %%%
%%%          Laurent Gosse, IAC-Rome, CNR, Italy            %%%
%%% ------------------------------------------------------- %%%
%%%      Distributed under GNU General Public License       %%%
%%% ------------------------------------------------------- %%%

function rhs = FellerRHS(t, Y)
    
    global e2 g N P
    
    rhs = zeros(N,1);
    
    dP         = P(3:N) - P(1:N-2);
    rhs(2:N-1) = Y(2:N-1).*((P(3:N) - P(2:N-1))./(Y(3:N) - Y(2:N-1))...
                 - (P(2:N-1) - P(1:N-2))./(Y(2:N-1) - Y(1:N-2)))./dP;
    rhs(N)     = -Y(N)*(P(N) - P(N-1))/((Y(N) - Y(N-1))*(P(N) - P(N-2)));

    rhs = -e2*exp(g*t)*rhs;

end % FellerRHS ()