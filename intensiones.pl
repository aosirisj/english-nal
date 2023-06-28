:- include('./traduccion/oraciones a juicios').
:- working_directory(CWD, CWD), atomic_list_concat([CWD, 'wordnet-prolog-master/wn_load'], WN), consult(WN).

categoria_atomo(Dict, Palabra, a):- es_categoria(Dict, Palabra, adjetivo).
categoria_atomo(Dict, Palabra, n):- es_categoria(Dict, Palabra, no_propio).
categoria_atomo(Dict, Palabra, n):- es_categoria(Dict, Palabra, propio).
categoria_atomo(Dict, Palabra, r):- es_categoria(Dict, Palabra, adverbio).
categoria_atomo(Dict, Palabra, v):- es_categoria(Dict, Palabra, verbo).

lema_categoria_sentido(Term, Lema, Categoria, Sentido):- atomic_list_concat([Lema, Categoria, Sentido], ".", Term).

%primeros_n es verdadero cuando los primeros N elementos de L1 son L2
%N - natural
%L1, L2 - listas

primeros_n(N, L1, L2) :- append(L2, _, L1), 
                         length(L2, N).
                         
%codificar(Term, Id) obtiene el Id de WN de un termino Term (nondet, inverso de interpretar)
%Term - termino
%Id - entero psoitivo

codificar(_, Term, Id):- lema_categoria_sentido(Term, Lema, Categoria, SAtomo),
                         atom_number(SAtomo, Sentido),
                         s(Id, _, Lema, Categoria, Sentido, _).
                         
codificar(Dict, Palabra, Id) :- not(lema_categoria_sentido(Palabra, _, _, _)),
                                lema(Palabra, Lema),
                                categoria_atomo(Dict, Palabra, CG), 
                                s(Id, _, Lema, CG, _, _).
                      
interpretar(Id, Term):- s(Id, _, Lema, CG, Sentido, _),
                        atomic_list_concat([Lema, '.', CG, '.', Sentido], Term), !.                                               
                         
%intension_todos(Term, Int) lee cada rama de los hiperonimos de WN de Term en Int. No importa.
%Term - termino
%Int - lista de terminos

intension_todos(Dict, Term, []) :- codificar(Dict, Term, IdTerm),
                                   not(hyp(IdTerm, _)).

intension_todos(Dict, Term, [A|B]) :- codificar(Dict, Term, Idterm),
                                      hyp(Idterm, HipIdTerm),
                                      interpretar(HipIdTerm, A),
                                      intension_todos(Dict, A, B).

%intension_n(Term, Int, N) lee N hiperonimos de WN de cada rama de Term en Int. No importa.
%Term - termino
%Int - lista de terminos
				 	
intension_n(Dict, Term, Int, N) :- intension_todos(Dict, Term, IntTodos),
                             primeros_n(N, IntTodos, Int);
                             intension_todos(Dict, Term, IntTodos),
                             not(primeros_n(N, IntTodos, Int)),
                             Int = IntTodos.                         

%afirmar_intension_juicio(Ext, L) supone que L es una lista con intension ordenada de Ext. Afirma las relaciones de herencia correspondientes, i.e., si L=[A1, A2] 
%tendremos en la base de conociemientos Ext->A1 (1.0, 0.9) y A1->A2 (1.0, 0.9).
%Ext - atomo
%L - lista de atomos 
afirmar_intension_juicio(Ext, L) :- L = [Int],
                                    (not(lema_categoria_sentido(Ext, _, _, _)) -> lema(Ext, Lema); Lema = Ext),
                                    assert(juicio(inheritance(Lema, Int), [1, 0.9])), !;
                                    L = [].

afirmar_intension_juicio(Ext, [A|B]) :- B \= [],
                                        afirmar_intension_juicio(Ext, [A]),
                                        afirmar_intension_juicio(A, B).
                                        
%importar_intension_juicio(Lista, N) obtiene una rama de hiperonimos de longitud N de WN de cada termino de Lista y afirma los juicios que se obtienen de estos. Si 
%importa.
%Term - termino
%N - entero positivo
                                
importar_intension_juicio(Dict, [Term], N):- findall(Int, intension_n(Dict, Term, Int, N), Ints),
                                             foreach(member(Int1, Ints), afirmar_intension_juicio(Term, Int1)).
					
importar_intension_juicio(Dict, [A|B], N) :- B \= [], 
                                             importar_intension_juicio(Dict, [A], N),
                                             importar_intension_juicio(Dict, B, N).
                                             
importar_intensiones(Dict, N):- findall(Palabra, (lema(Palabra, Lema), not(es_categoria(Dict, Palabra, propio)), 
                                                  Lema \= be, Lema \= have), Ps),
                                (juicio(inheritance(_, 'person.n.1'), _) -> append(Ps, ['person.n.1'], P1); P1 = Ps),
                                (juicio(inheritance(_, 'location.n.1'), _) -> append(P1, ['location.n.1'], P2); P2 = P1),
                                (juicio(inheritance(_, 'organization.n.1'), _) -> append(P2, ['organization.n.1'], Palabras); 
                                                                                  P2 = Palabras),
                                importar_intension_juicio(Dict, Palabras, N).





                               
