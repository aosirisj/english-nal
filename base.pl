%Predicados comunes a toda la traducción

:-use_module(library(pcre)).
:- include('/home/alejandra/Documents/tareasDCC/eso/traduccion/lemas/parsed.txt').

%is_odd_element(L, A) es verdadero cuando A tiene un índice impar en L.
%L - Lista
%A - Any
is_odd_element([A], A).

is_odd_element([A, _|B], X) :- A = X, !;
                               is_odd_element(B, X).
                               
anterior(L, P, E):- append(A, [E|_], L),
                    last(A, P).
                    
zip_unzip(Primeros, Segundos, Pares):- maplist([P, S, P:S] >> true, Primeros, Segundos, Pares).                                                                        
                               
imprimir(Lista) :- foreach(member(X, Lista), writeln(X)).                                                                  

%Listas de abreviaciones de PoS tags de Penn Treebank. Para nuestros fines sólo es necesario identificar la función de estos 4 tipos.
adjetivo(T):- member(T, ['JJ']).

no_propio(T):- member(T, ['NN', 'NNS', 'NNP', 'NNPS']).

propio(T):- member(T, ['NNP', 'NNPS']).

adverbio(T):- member(T, ['RB', 'RBR', 'RBS']).

verbo(T):- member(T, ['VB', 'VBD', 'VBG', 'VBN', 'VBP', 'VBZ']).

determinante(T):- member(T, ['DT', 'PDT', 'PRP$', 'WDT', 'WP$']).
                                                 
                                                                                                    
