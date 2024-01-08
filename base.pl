%Predicados comunes a toda la traducción

:-use_module(library(pcre)).
%:- include('./traduccion/lemas/parsed.txt').

:-assert(juicio(inheritance('thing.n.08', 'entity.n.01'), [1, 0.9])).

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

superlativo(T):- member(T, ['JJS']).

comparativo(T):- member(T, ['JJR']).

no_propio(T):- member(T, ['NN', 'NNS', 'NNP', 'NNPS']).

propio(T):- member(T, ['NNP', 'NNPS']).

adverbio(T):- member(T, ['RB', 'RBR', 'RBS']).

verbo(T):- member(T, ['VB', 'VBD', 'VBG', 'VBN', 'VBP', 'VBZ']).

determinante(T):- member(T, ['DT', 'PDT', 'PRP$', 'WDT', 'WP$']).

preposicion(T):- member(T, ['IN']).

modal(T):- member(T, ['MD']).

tobe(T):- member(T, ['am', 'are', 'is', 'was', 'were', 'be', 'been', 'being']).

localization(T):- member(T, ['Boston', 'barn', 'room', 'house', 'party', 'supermarket', 'food market', 'store', 'market']), !;
                  juicio(inheritance(T, 'location.n.01'), [1, 0.9]).
                  
time(T):- member(T, ['Friday']), !;
          juicio(inheritance(T, 'calendar day.n.01'), [1, 0.9]).
          
advcl_place(T):- member(T, [where, wherever, anywhere, everywhere]).

advcl_time(T):- member(T, [when, before, after, while, until, sooner, later, as]).

advcl_concession(T):- member(T, [although, though, while, but]).

advcl_purpose(T):- member(T, [so]).

advcl_reason(T):- member(T, [because, since, due]).

advcl_manner(T):- member(T, [like]).

advcl_comparison(T):- member(T, [as]).
                                                                                                    
