:- include('/home/alejandra/Documents/tareasDCC/eso/traduccion/arbol').

encontrar_nsubj(Tripletas, Cabeza, Dependiente):- member(T, Tripletas),
                                                  tripleta(T, Cab, PosC, nsubj, Depe, PosD),
                                                  atomic_list_concat([Cab, '-', PosC], Cabeza),
                                                  atomic_list_concat([Depe, '-', PosD], Dependiente).
                                                  
encontrar_nsubjp(Tripletas, Cabeza, Dependiente):- member(T, Tripletas),
                                                  tripleta(T, Cab, PosC, 'nsubj:pass', Depe, PosD),
                                                  atomic_list_concat([Cab, '-', PosC], Cabeza),
                                                  atomic_list_concat([Depe, '-', PosD], Dependiente).

encontrar_dep_sin_corte(Tripletas, Dep, Cabeza, Dependiente):- member(T, Tripletas),
                                                               tripleta(T, Cab, PosC, Dep, Depe, PosD),
                                                               atomic_list_concat([Cab, '-', PosC], Cabeza),
                                                               atomic_list_concat([Depe, '-', PosD], Dependiente).
                                                                                  
encontrar_dep(Tripletas, Dep, Cabeza, Dependiente):- member(T, Tripletas),
                                                     tripleta(T, Cab, PosC, Dep, Depe, PosD),
                                                     atomic_list_concat([Cab, '-', PosC], Cabeza),
                                                     atomic_list_concat([Depe, '-', PosD], Dependiente), !;
                                                     member(Root, Tripletas),
                                                     tripleta(Root, _, 0, root, Raiz, PosR),
                                                     atomic_list_concat([Raiz, '-', PosR], Cabeza),
                                                     Dependiente = _. 
                                                  
activa_a_juicio(Dependencias, judgment(Sujeto, Predicado, [1, 0.9])):- split_string(Dependencias, "\n", "", Tripletas),
                                                                       encontrar_nsubj(Tripletas, Predicado, Suj),
                                                                       encontrar_dep(Tripletas, obj, Predicado, Obj),
                                                                       encontrar_dep_sin_corte(Tripletas, iobj, Predicado, Iobj),
                                                                       Sujeto = [Suj, Obj, Iobj], !;
                                                                       split_string(Dependencias, "\n", "", Tripletas),
                                                                       encontrar_nsubj(Tripletas, Predicado, Suj),
                                                                       encontrar_dep(Tripletas, obj, Predicado, Obj),
                                                                       encontrar_dep(Tripletas, 'obl:to', Predicado, Iobj),
                                                                       Sujeto = [Suj, Obj, Iobj].
                                                                           
pasiva_a_juicio(Dependencias, judgment(Sujeto, Predicado, [1, 0.9])):- split_string(Dependencias, "\n", "", Tripletas),
                                                                       encontrar_nsubjp(Tripletas, Predicado, Obj),
                                                                       encontrar_dep(Tripletas, 'obl:to', Predicado, Iobj),
                                                                       encontrar_dep(Tripletas, 'obl:by', Predicado, Suj),
                                                                       Sujeto = [Suj, Obj, Iobj].
                                                                       
idinstancia_a_juicios(IdIns, Juicios):- encontrar_oraciones_id(IdIns, _, Deps), 
                                        findall(Juicio, (nth1(N, Deps, D), activa_a_juicio(D, Juicio); 
                                                         nth1(N, Deps, D), pasiva_a_juicio(D, Juicio)), Juicios).
                                                         
                                                         
                                                         
                                                         
