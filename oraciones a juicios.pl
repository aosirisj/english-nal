:- include('/home/alejandra/Documents/tareasDCC/eso/traduccion/palabras a terminos').
                                                  
activa_a_juicio(Dict, Deps, juicio(inheritance(SujetoT, PredicadoT), [1, 0.9])):- encontrar_nsubj(Deps, Accion, Suj),
                                                                     not(encontrar_dep_sin_corte(Deps, cop, Accion, _)),
                                                                     encontrar_dep_sin_corte(Deps, iobj, Accion, Iobj),
                                                                     palabra_termino(Dict, Deps, Accion, AccionT),
                                                                     (encontrar_dep_sin_corte(Deps, advmod, Accion, Adv) -> 
                                                                      palabra_termino(Dict, Deps, Adv, AdvT),
                                                                      atomic_list_concat([AccionT, ' & ', AdvT], PredicadoT);
                                                                      PredicadoT = AccionT), 
                                                                     encontrar_dep(Deps, obj, Accion, Obj),
                                                                     palabra_termino(Dict, Deps, Suj, SujT),
                                                                     palabra_termino(Dict, Deps, Obj, ObjT),
                                                                     palabra_termino(Dict, Deps, Iobj, IobjT),
                                                                     SujetoT = [SujT, ObjT, IobjT], !;
                                                                     encontrar_nsubj(Deps, Accion, Suj),
                                                                     not(encontrar_dep_sin_corte(Deps, cop, Accion, _)),
                                                                     encontrar_dep(Deps, obj, Accion, Obj),
                                                                     encontrar_dep(Deps, 'obl:to', Accion, Iobj),
                                                                     palabra_termino(Dict, Deps, Accion, AccionT),
                                                                     palabra_termino(Dict, Deps, Suj, SujT),
                                                                     palabra_termino(Dict, Deps, Obj, ObjT),
                                                                     palabra_termino(Dict, Deps, Iobj, IobjT),
                                                                     SujetoT = [SujT, ObjT, IobjT],
                                                                     (encontrar_dep_sin_corte(Deps, advmod, Accion, Adv) -> 
                                                                      palabra_termino(Dict, Deps, Adv, AdvT),
                                                                      atomic_list_concat([AccionT, ' & ', AdvT], PredicadoT);
                                                                      PredicadoT = AccionT).
                                                                           
pasiva_a_juicio(Dict, Deps, juicio(inheritance(SujetoT, PredicadoT), [1, 0.9])):- encontrar_nsubjp(Deps, Accion, Obj),
                                                                     palabra_termino(Dict, Deps, Accion, AccionT),
                                                                     palabra_termino(Dict, Deps, Obj, ObjT),
                                                                     encontrar_dep(Deps, 'obl:to', Accion, Iobj),
                                                                     palabra_termino(Dict, Deps, Iobj, IobjT),
                                                                     encontrar_dep(Deps, 'obl:by', Accion, Suj),
                                                                     palabra_termino(Dict, Deps, Suj, SujT),
                                                                     SujetoT = [SujT, ObjT, IobjT],
                                                                     (encontrar_dep_sin_corte(Deps, advmod, Accion, Adv) -> 
                                                                      palabra_termino(Dict, Deps, Adv, AdvT),
                                                                      atomic_list_concat([AccionT, ' & ', AdvT], PredicadoT);
                                                                      PredicadoT = AccionT).
                                                                       
copular(Dict, Deps, juicio(inheritance(SujetoT, PredicadoT), [1, 0.9])):- encontrar_nsubj(Deps, Predicado, Sujeto),
                                                             not(es_categoria(Dict, Predicado, verbo)),
                                                             palabra_termino(Dict, Deps, Predicado, PredicadoT),
                                                             palabra_termino(Dict, Deps, Sujeto, SujetoT).
                                                               
adjetivo_a_juicio(Dict, Deps, juicio(inheritance(SujetoT, PredicadoT), [1,0.9])):- encontrar_dep_sin_corte(Deps, amod, Sujeto, Predicado),
                                                                      not(es_categoria(Dict, Predicado, superlativo)),
                                                                      palabra_termino(Dict, Deps, Predicado, PredicadoT),
                                                                      palabra_termino(Dict, Deps, Sujeto, SujetoT),
                                                                      sub_atom(SujetoT, 0, 1, _, '{').
                                           
idinstancia_a_juicios(IdIns, Juicios):- encontrar_CGs_dependencias_id(IdIns, Dict, Deps),
                                        findall(Propiedad, (adjetivo_a_juicio(Dict, Deps, Propiedad)), Adjs),
                                        findall(Juicio, (copular(Dict, Deps, Juicio);
                                                         activa_a_juicio(Dict, Deps, Juicio); 
                                                         pasiva_a_juicio(Dict, Deps, Juicio)), Oraciones),
                                        append(Adjs, Oraciones, Juicios),
                                        maplist(assert, Juicios).
                                                         
                                                         
                                                         
                                                         
