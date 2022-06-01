:- include('/home/alejandra/Documents/tareasDCC/eso/traduccion/palabras a terminos').
                                                  
activa_a_juicio(Dict, Deps, juicio(SujetoT, PredicadoT, [1, 0.9])):- encontrar_nsubj(Deps, Accion, Suj),
                                                                       palabra_termino(Dict, Deps, Accion, AccionT),
                                                                       palabra_termino(Dict, Deps, Suj, SujT),
                                                                       encontrar_dep(Deps, obj, Predicado, Obj),
                                                                       palabra_termino(Dict, Deps, Obj, ObjT),
                                                                       encontrar_dep_sin_corte(Deps, iobj, Predicado, Iobj),
                                                                       palabra_termino(Dict, Deps, Iobj, IobjT),
                                                                       encontrar_dep(Deps, 'advmod', Accion, Adv),
                                                                       palabra_termino(Dict, Deps, Adv, AdvT),
                                                                       atomic_list_concat([AccionT, ' & ', AdvT], PredicadoT),
                                                                       SujetoT = [SujT, ObjT, IobjT], !;
                                                                       encontrar_nsubj(Deps, Accion, Suj),
                                                                       palabra_termino(Dict, Deps, Accion, AccionT),
                                                                       palabra_termino(Dict, Deps, Suj, SujT),
                                                                       encontrar_dep(Deps, obj, Predicado, Obj),
                                                                       palabra_termino(Dict, Deps, Obj, ObjT),
                                                                       encontrar_dep(Deps, 'obl:to', Predicado, Iobj),
                                                                       palabra_termino(Dict, Deps, Iobj, IobjT),
                                                                       encontrar_dep(Deps, 'advmod', Accion, Adv),
                                                                       palabra_termino(Dict, Deps, Adv, AdvT),
                                                                       atomic_list_concat([AccionT, ' & ', AdvT], PredicadoT),
                                                                       SujetoT = [SujT, ObjT, IobjT].
                                                                           
pasiva_a_juicio(Dict, Deps, juicio(SujetoT, PredicadoT, [1, 0.9])):- encontrar_nsubjp(Deps, Accion, Obj),
                                                                       palabra_termino(Dict, Deps, Accion, AccionT),
                                                                       palabra_termino(Dict, Deps, Obj, ObjT),
                                                                       encontrar_dep(Deps, 'obl:to', Predicado, Iobj),
                                                                       palabra_termino(Dict, Deps, Iobj, IobjT),
                                                                       encontrar_dep(Deps, 'obl:by', Predicado, Suj),
                                                                       palabra_termino(Dict, Deps, Suj, SujT),
                                                                       encontrar_dep(Deps, 'advmod', Accion, Adv),
                                                                       palabra_termino(Dict, Deps, Adv, AdvT),
                                                                       atomic_list_concat([AccionT, ' & ', AdvT], PredicadoT),
                                                                       SujetoT = [SujT, ObjT, IobjT].
                                                                       
copular(Dict, Deps, juicio(SujetoT, PredicadoT, [1, 0.9])):- encontrar_nsubj(Deps, Predicado, Sujeto),
                                                               encontrar_dep(Deps, cop, Predicado, _),
                                                               palabra_termino(Dict, Deps, Predicado, PredicadoT),
                                                               palabra_termino(Dict, Deps, Sujeto, SujetoT).
                                                               
adjetivo_a_juicio(Dict, Deps, juicio(SujetoT, PredicadoT, [1,0.9])):- encontrar_dep(Deps, amod, Sujeto, Predicado),
                                                                      es_categoria(Dict, Predicado, adjetivo),
                                                                      palabra_termino(Dict, Deps, Predicado, PredicadoT),
                                                                      palabra_termino(Dict, Deps, Sujeto, SujetoT).
                                           
idinstancia_a_juicios(IdIns, Juicios):- encontrar_CGs_dependencias_id(IdIns, Dict, Deps),
                                        findall(Propiedad, (adjetivo_a_juicio(Dict, Deps, Propiedad)), Adjs),
                                        findall(Juicio, (copular(Dict, Deps, Juicio);
                                                         activa_a_juicio(Dict, Deps, Juicio); 
                                                         pasiva_a_juicio(Dict, Deps, Juicio)), Oraciones),
                                        append(Adjs, Oraciones, Juicios),
                                        maplist(assert, Juicios).
                                                         
                                                         
                                                         
                                                         
