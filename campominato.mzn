% CAMPOMINATO (Minesweeper)

% Data una matrice di punti e numeri individuare le mine presenti.
% Le celle con un numero indicano la quantità di mine presenti attorni alla cella.
% I punti rappresentano le celle non ancora risolte.

int: r; % righe
int: c; % colonne
int: X = -1; % celle sconosciute
int: nmines; % numero di mine da trovare


% Matrice di partenza
array[1..r, 1..c] of -1..8: game;

% La matrice contenente le mine (da cercare)
array[1..r, 1..c] of var 0..1: mines;

include "globals.mzn";

% il numero di mine da trovare
constraint sum(mines) == nmines;

constraint
    % per ogni riga e colonna della matrice
    forall(i in 1..r, j in 1..c) (
       % per ogni cella maggiore o uguale a zero
       % quel numero corrisponde al numero di bombe adiacenti alla cella
      (game[i,j] >= 0) -> game[i,j]  = sum(a,b in {-1,0,1} where % imposto di cercare nell'intorno
                                            i+a > 0  /\ j+b >  0 /\
                                            i+a <= r /\ j+b <= c)
                                        (mines[i+a,j+b]) % la somma degli 1 (bombe) nell'intorno della cella i,j deve essere uguale al valore game[i,j]
      /\ % se c'è un numero non c'è una mina
      (game[i,j] > X -> mines[i,j] = 0) 
    )
;

% risolvo
solve :: int_search([mines[i,j] | i in 1..r, j in 1..c], first_fail, indomain_min, complete) satisfy;


output ["Mine:\n" ] ++
[show_int(2,mines[i, k]) ++ if k==c then "\n" else "" endif | i in 1..r, k in 1..c];
