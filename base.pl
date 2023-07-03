%Predicados comunes a toda la traducción

:-use_module(library(pcre)).
%:- include('./traduccion/lemas/parsed.txt').

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

numerar(Lista, Dict):- findall(Numerado, (nth1(N, Lista, Llave:Cat), atomic_list_concat([Llave, '-', N], Numero), Numerado = Numero:Cat), Numerados),
                       dict_create(Dict, _, Numerados).
                       
palabra_pos(PalabraConPos, Palabra, Pos):- atomic_list_concat([Palabra, Pos], '-', PalabraConPos).                            

%Listas de abreviaciones de PoS tags de Penn Treebank. Para nuestros fines sólo es necesario identificar la función de estos 4 tipos.
adjetivo(T):- member(T, ['JJ']).

superlativo(T):- member(T, ['JJR', 'JJS']).

comparativo(T):- member(T, ['JJR']).

no_propio(T):- member(T, ['NN', 'NNS', 'NNP', 'NNPS']).

propio(T):- member(T, ['NNP', 'NNPS']).

adverbio(T):- member(T, ['RB', 'RBR', 'RBS']).

verbo(T):- member(T, ['VB', 'VBD', 'VBG', 'VBN', 'VBP', 'VBZ']).

determinante(T):- member(T, ['DT', 'PDT', 'PRP$', 'WDT', 'WP$']).

preposicion(T):- member(T, ['IN']).

tobe(T):- member(T, ['am', 'are', 'is', 'was', 'were', 'be', 'been', 'being']).                         
                                                                                                    
