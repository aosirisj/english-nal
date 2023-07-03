:- include('./traduccion/palabras a terminos').
                                 
np_advmod(Dict, Deps, Predicado, ModT):- encontrar_dep_sin_corte(Deps, 'obl:npmod', Predicado, Sustantivo),
                                         mods(Dict, Deps, Sustantivo, _, ModT), !;
                                         encontrar_dep_sin_corte(Deps, 'obl:npmod', Predicado, Sustantivo),
                                         palabra_termino(Dict, Deps, Sustantivo, ModT).
                                         
ccomp_juicio_nocopular(Dict, Deps, Accion, inheritance(SujetoT, PredicadoT)):- not(encontrar_dep_sin_corte(Deps, cop, Accion, _)),
								     es_categoria(Dict, Accion, verbo),
								     palabra_pos(Accion, Pred, _),
                                                                     not(tobe(Pred)),
								     %Analisis objeto ccomp
								     encontrar_dep_sin_corte(Deps, ccomp, Accion, Sub),
                                                                     (ccomp_juicio_nocopular(Dict, Deps, Sub, ObjT);
                                                                      ccomp_juicio_copular(Dict, Deps, Sub, ObjT);
                                                                      xcomp_juicio_nocopular(Dict, Deps, Sub, ObjT);
                                                                      xcomp_juicio_copular(Dict, Deps, Sub, ObjT);
                                                                      activa_a_juicio(Dict, Deps, Sub, ObjT);
                                                                      pasiva_a_juicio(Dict, Deps, Sub, ObjT);
                                                                      copular(Dict, Deps, Sub, ObjT)),
								     %Analisis sujeto
								     (encontrar_csubj(Dict, Deps, Accion, SujT);
								      encontrar_nsubj(Deps, Accion, Suj),
								      phrase(Dict, Deps, Suj, SujT)),
                                                                     %Analisis objeto indirecto atomico
                                                                     (encontrar_dep_sin_corte(Deps, iobj, Accion, Iobj);
                                                                      encontrar_dep(Deps, 'obl:to', Accion, Iobj)),
                                                                      phrase(Dict, Deps, Iobj, IobjT),
                                                                     %Analisis predicado (herencia)
                                                                     phrase(Dict, Deps, Accion, PredicadoT),
                                                                     %Analisis sujeto herencia
                                                                     SujetoT = [SujT, ObjT, IobjT].
                                                                     
ccomp_juicio_copular(Dict, Deps, Predicado, inheritance(SujetoT, PredicadoT)):- encontrar_dep_sin_corte(Deps, cop, Predicado, _),
								     %Analisis objeto ccomp
								     encontrar_dep_sin_corte(Deps, ccomp, Predicado, Sub),
                                                                     (ccomp_juicio_nocopular(Dict, Deps, Sub, ObjT);
                                                                      ccomp_juicio_copular(Dict, Deps, Sub, ObjT);
                                                                      xcomp_juicio_nocopular(Dict, Deps, Sub, ObjT);
                                                                      xcomp_juicio_copular(Dict, Deps, Sub, ObjT);
                                                                      activa_a_juicio(Dict, Deps, Sub, ObjT);
                                                                      pasiva_a_juicio(Dict, Deps, Sub, ObjT);
                                                                      copular(Dict, Deps, Sub, ObjT)),
								     %Analisis sujeto atomico
								     (encontrar_csubj(Dict, Deps, Predicado, SujT);
								      encontrar_nsubj(Deps, Predicado, Suj),
								     phrase(Dict, Deps, Suj, SujT)),
                                                                     %Analisis predicado (herencia)
                                                                     phrase(Dict, Deps, Predicado, PredicadoT),
                                                                     %Analisis sujeto herencia
                                                                     SujetoT = [SujT, ObjT].
                                                                     
xcomp_juicio_nocopular(Dict, Deps, Accion, inheritance(SujetoT, PredicadoT)):- not(encontrar_dep_sin_corte(Deps, cop, Accion, _)),
								     es_categoria(Dict, Accion, verbo),
								     palabra_pos(Accion, Pred, _),
                                                                     not(tobe(Pred)),
								     %Analisis objeto xcomp
								     encontrar_dep_sin_corte(Deps, xcomp, Accion, Sub),
                                                                     (ccomp_juicio_nocopular(Dict, Deps, Sub, ObjT);
                                                                      ccomp_juicio_copular(Dict, Deps, Sub, ObjT);
                                                                      xcomp_juicio_nocopular(Dict, Deps, Sub, ObjT);
                                                                      xcomp_juicio_copular(Dict, Deps, Sub, ObjT);
                                                                      analisis_xcomp_nocopular(Dict, Deps, Sub, ObjT);
                                                                      analisis_xcomp_copular(Dict, Deps, Sub, ObjT)),
								     %Analisis sujeto atomico
								     (encontrar_csubj(Dict, Deps, Accion, SujT);
								      encontrar_nsubj(Deps, Accion, Suj),
								     phrase(Dict, Deps, Suj, SujT)),
                                                                     %Analisis objeto indirecto atomico
                                                                     (encontrar_dep_sin_corte(Deps, iobj, Accion, Iobj);
                                                                      encontrar_dep(Deps, 'obl:to', Accion, Iobj)),
                                                                     phrase(Dict, Deps, Iobj, IobjT),
                                                                     %Analisis predicado (herencia)
                                                                     phrase(Dict, Deps, Accion, PredicadoT),
                                                                     %Analisis sujeto herencia
                                                                     SujetoT = [SujT, ObjT, IobjT].
                                                                     
xcomp_juicio_copular(Dict, Deps, Predicado, inheritance(SujetoT, PredicadoT)):- encontrar_dep_sin_corte(Deps, cop, Predicado, _),
								     %Analisis objeto ccomp
								     encontrar_dep_sin_corte(Deps, xcomp, Predicado, Sub),
                                                                     (ccomp_juicio_nocopular(Dict, Deps, Sub, ObjT);
                                                                      ccomp_juicio_copular(Dict, Deps, Sub, ObjT);
                                                                      xcomp_juicio_nocopular(Dict, Deps, Sub, ObjT);
                                                                      xcomp_juicio_copular(Dict, Deps, Sub, ObjT);
                                                                      analisis_xcomp_nocopular(Dict, Deps, Sub, ObjT);
                                                                      analisis_xcomp_copular(Dict, Deps, Sub, ObjT)),
								     %Analisis sujeto atomico
								     (encontrar_csubj(Dict, Deps, Predicado, SujT);
								      encontrar_nsubj(Deps, Predicado, Suj),
								     phrase(Dict, Deps, Suj, SujT)),
                                                                     %Analisis predicado (herencia)
                                                                     phrase(Dict, Deps, Predicado, PredicadoT),
                                                                     %Analisis sujeto herencia
                                                                     SujetoT = [SujT, ObjT].
                                                                     
analisis_xcomp_nocopular(Dict, Deps, Sub, inheritance(SujetoT, PredicadoT)):- es_categoria(Dict, Sub, verbo),
								     not(encontrar_dep_sin_corte(Deps, cop, Sub, _)),
								     palabra_pos(Sub, Pred, _),
                                                                     not(tobe(Pred)),
								     encontrar_dep_sin_corte(Deps, xcomp, Accion, Sub),
								     %Analisis sujeto atomico
								     (encontrar_dep_sin_corte(Deps, obj, Accion, Suj) -> 
                                                                      phrase(Dict, Deps, Suj, SujT);
                                                                      encontrar_csubj(Dict, Deps, Accion, SujT);
								      encontrar_nsubj(Deps, Accion, Suj),
								      phrase(Dict, Deps, Suj, SujT)),
                                                                      %Analisis objeto atomico
								     encontrar_dep(Deps, obj, Sub, Obj),
                                                                     phrase(Dict, Deps, Obj, ObjT),
								     %Analisis objeto indirecto atomico
                                                                     (encontrar_dep_sin_corte(Deps, iobj, Sub, Iobj);
                                                                      encontrar_dep(Deps, 'obl:to', Sub, Iobj)),
                                                                     phrase(Dict, Deps, Iobj, IobjT),
                                                                     %Analisis predicado atomico (herencia)
                                                                     phrase(Dict, Deps, Sub, PredicadoT),
                                                                     %Analisis sujeto herencia
                                                                     SujetoT = [SujT, ObjT, IobjT].
                                                                     
analisis_xcomp_copular(Dict, Deps, Sub, inheritance(SujetoT, PredicadoT)):- %encontrar_dep_sin_corte(Deps, cop, Sub, _),
								     encontrar_dep_sin_corte(Deps, xcomp, Accion, Sub),
								     %Analisis sujeto atomico
								     (encontrar_dep_sin_corte(Deps, obj, Accion, Suj) -> 
                                                                      phrase(Dict, Deps, Suj, SujetoT);
                                                                     (encontrar_csubj(Dict, Deps, Accion, SujetoT);
								      encontrar_dep(Deps, nsubj, Accion, Suj),
								      phrase(Dict, Deps, Suj, SujetoT))),
								     %Analisis predicado
								     phrase(Dict, Deps, Sub, PredicadoT).
                                                                     
activa_a_juicio(Dict, Deps, Accion, inheritance(SujetoT, PredicadoT)):- not(encontrar_dep_sin_corte(Deps, ccomp, Accion, _)),
									not(encontrar_dep_sin_corte(Deps, xcomp, Accion, _)),
								     not(encontrar_dep_sin_corte(Deps, cop, Accion, _)),
								     es_categoria(Dict, Accion, verbo),
								     palabra_pos(Accion, Pred, _),
                                                                     not(tobe(Pred)),
								     %Analisis sujeto
								     (encontrar_csubj(Dict, Deps, Accion, SujT);
								      not(encontrar_csubj(Dict, Deps, Accion, SujT)),
								      not(encontrar_csubjp(Dict, Deps, Accion, SujT)),
								      not(encontrar_nsubjp(Deps, Accion, Suj)),
								      encontrar_dep(Deps, nsubj, Accion, Suj),
								      phrase(Dict, Deps, Suj, SujT)),
								     %Analisis objeto atomico
								     encontrar_dep(Deps, obj, Accion, Obj),
                                                                     phrase(Dict, Deps, Obj, ObjT),
                                                                     %Analisis objeto indirecto atomico
                                                                     (encontrar_dep_sin_corte(Deps, iobj, Accion, Iobj), !;
                                                                      encontrar_dep(Deps, 'obl:to', Accion, Iobj)),
                                                                     phrase(Dict, Deps, Iobj, IobjT),
                                                                     %Analisis predicado atomico (herencia)
                                                                     phrase(Dict, Deps, Accion, PredicadoT),
                                                                     %Analisis sujeto herencia
                                                                     SujetoT = [SujT, ObjT, IobjT].
                                                                           
pasiva_a_juicio(Dict, Deps, Accion, inheritance(SujetoT, PredicadoT)):- not(encontrar_dep_sin_corte(Deps, ccomp, Accion, _)),
									not(encontrar_dep_sin_corte(Deps, xcomp, Accion, _)),
									es_categoria(Dict, Accion, verbo),
								     %Analisis objeto
								     (encontrar_csubjp(Dict, Deps, Accion, ObjT);
								      not(encontrar_csubjp(Dict, Deps, Accion, ObjT)),
								      encontrar_nsubjp(Deps, Accion, Obj),
                                                                      phrase(Dict, Deps, Obj, ObjT)),
                                                                     %Analisis recipiente
                                                                     encontrar_dep(Deps, 'obl:to', Accion, Iobj),
                                                                     phrase(Dict, Deps, Iobj, IobjT),
                                                                     %Analisis agente
                                                                     encontrar_dep(Deps, 'obl:by', Accion, Suj),
                                                                     phrase(Dict, Deps, Suj, SujT),
                                                                     %Analisis sujeto de herencia
                                                                     SujetoT = [SujT, ObjT, IobjT],
                                                                     %Analisis predicado de herencia
                                                                     phrase(Dict, Deps, Accion, PredicadoT).
                                                                       
copular(Dict, Deps, Predicado, inheritance(SujetoT, PredicadoT)):- %relacion adjetivo
                                                                   encontrar_dep_sin_corte(Deps, cop, Predicado, _),
							     not(encontrar_dep_sin_corte(Deps, ccomp, Predicado, _)),
							     not(encontrar_dep_sin_corte(Deps, xcomp, Predicado, _)),
							     (es_categoria(Dict, Predicado, adjetivo),
				                              encontrar_dep_con_prep(Dict, Deps, obl, Predicado, Dependiente, Prep),
				                              atomic_list_concat(['[', Predicado, ' ', Prep, ']'], PredicadoT),
				                              phrase(Dict, Deps, Dependiente, ObjT),
				                              (encontrar_csubj(Dict, Deps, Predicado, SujT);
							      encontrar_nsubj(Deps, Predicado, Suj),
							      phrase(Dict, Deps, Suj, SujT)),
				                             SujetoT = [SujT, ObjT]), !;
				                             %relacion adjetivo comparativo
                                                             encontrar_dep_sin_corte(Deps, cop, Predicado, _),
							     not(encontrar_dep_sin_corte(Deps, ccomp, Predicado, _)),
							     not(encontrar_dep_sin_corte(Deps, xcomp, Predicado, _)),
							     (es_categoria(Dict, Predicado, comparativo),
				                              encontrar_dep_con_prep(Dict, Deps, obl, Predicado, Dependiente, _),
				                              atomic_list_concat(['[', Predicado, ']'], PredicadoT),
				                              phrase(Dict, Deps, Dependiente, ObjT),
				                              (encontrar_csubj(Dict, Deps, Predicado, SujT);
							      encontrar_nsubj(Deps, Predicado, Suj),
							      phrase(Dict, Deps, Suj, SujT)),
				                             SujetoT = [SujT, ObjT]), !;
				                             %relacion adjetivo superlativo
                                                             encontrar_dep_sin_corte(Deps, cop, Predicado, _),
							     not(encontrar_dep_sin_corte(Deps, ccomp, Predicado, _)),
							     not(encontrar_dep_sin_corte(Deps, xcomp, Predicado, _)),
							     (es_categoria(Dict, Predicado, superlativo),
				                              %encontrar_dep_con_prep(Dict, Deps, obl, Predicado, Dependiente, _),
				                              atomic_list_concat(['[', Predicado, ']'], PredicadoT),
				                              %phrase(Dict, Deps, Dependiente, ObjT),
				                              (encontrar_csubj(Dict, Deps, Predicado, SujT);
							      encontrar_nsubj(Deps, Predicado, Suj),
							      phrase(Dict, Deps, Suj, SujT)),
				                             SujetoT = [SujT, _]), !;
				                             %modificador adverbial
				                             encontrar_dep_sin_corte(Deps, cop, Predicado, _),
							     not(encontrar_dep_sin_corte(Deps, ccomp, Predicado, _)),
							     not(encontrar_dep_sin_corte(Deps, xcomp, Predicado, _)),
							     (encontrar_csubj(Dict, Deps, Predicado, SujetoT);
							      encontrar_nsubj(Deps, Predicado, Suj),
							      phrase(Dict, Deps, Suj, SujetoT)),
							     np_advmod(Dict, Deps, Predicado, AdvMod),
							     atomic_list_concat(['[', AdvMod, ']'], AdvModT),
							     palabra_termino(Dict, Deps, Predicado, PredT),
							     atomic_list_concat([PredT, ' & ', AdvModT], PredicadoT), !;
							     %otro
							     encontrar_dep_sin_corte(Deps, cop, Predicado, _),
							     not(encontrar_dep_sin_corte(Deps, ccomp, Predicado, _)),
							     not(encontrar_dep_sin_corte(Deps, xcomp, Predicado, _)),
							     (encontrar_csubj(Dict, Deps, Predicado, SujetoT);
							      encontrar_nsubj(Deps, Predicado, Suj),
							      phrase(Dict, Deps, Suj, SujetoT)),
							     phrase(Dict, Deps, Predicado, PredicadoT).%, !;
				                             %encontrar_dep_sin_corte(Deps, cop, Predicado, _),
							     %not(encontrar_dep_sin_corte(Deps, ccomp, Predicado, _)),
							     %not(encontrar_dep_sin_corte(Deps, xcomp, Predicado, _)),
				                             % palabra_termino(Dict, Deps, Predicado, PredicadoT),
                                                             %(encontrar_csubj(Dict, Deps, Predicado, SujetoT);
							     % encontrar_nsubj(Deps, Predicado, Suj),
							     % palabra_termino(Dict, Deps, Suj, SujetoT)).
                                                             %Falta agregar caso en el que Predicado es clausula
                                                               
adjetivo_a_juicio(Dict, Deps, juicio(inheritance(SujetoT, PredicadoT), [1,0.9])):- encontrar_dep_sin_corte(Deps, amod, Sujeto, Predicado),
                                                                      not(es_categoria(Dict, Predicado, superlativo)),
                                                                      not(es_categoria(Dict, Predicado, comparativo)),
                                                                      (mods(Dict, Deps, Predicado, _, ModT),
                                                                       atomic_list_concat(['[', ModT, ']'], PredicadoT);
                                                                      phrase(Dict, Deps, Predicado, PredicadoT)),
                                                                      phrase(Dict, Deps, Sujeto, SujetoT),
                                                                      sub_atom(SujetoT, 0, 1, _, '{').
                                                                      
expletivo(Dict, Deps, Predicado, inheritance(_, SujetoT)):- encontrar_dep_sin_corte(Deps, expl, Predicado, _),
                                                            palabra_pos(Predicado, Pred, _),
                                                            tobe(Pred),
                                                            encontrar_nsubj(Deps, Predicado, Sujeto),
                                                            phrase(Dict, Deps, Sujeto, SujetoT). %; falta oblicuo
                                                                      
oracion_a_juicio(Dict, Deps, juicio(Herencia, [1,0.9])):- member(Root, Deps),
							  tripleta(Root, _, 0, root, Raiz, PosR),
							  atomic_list_concat([Raiz, '-', PosR], Cabeza),
							  (ccomp_juicio_nocopular(Dict, Deps, Cabeza, Herencia);
							   ccomp_juicio_copular(Dict, Deps, Cabeza, Herencia);
							   xcomp_juicio_nocopular(Dict, Deps, Cabeza, Herencia);
							   xcomp_juicio_copular(Dict, Deps, Cabeza, Herencia);
							   activa_a_juicio(Dict, Deps, Cabeza, Herencia);
                                                           pasiva_a_juicio(Dict, Deps, Cabeza, Herencia);
                                                           copular(Dict, Deps, Cabeza, Herencia);
                                                           expletivo(Dict, Deps, Cabeza, Herencia)).

idinstancia_a_juicios(IdIns, Juicios):- encontrar_CGs_dependencias_id(IdIns, Dict, Deps),
                                        findall(Propiedad, (adjetivo_a_juicio(Dict, Deps, Propiedad)), Adjs),
                                        findall(Juicio, oracion_a_juicio(Dict, Deps, Juicio), Oraciones),
                                        append(Adjs, Oraciones, Juicios),
                                        maplist(assert, Juicios).
                                                         
                                                         
                                                         
                                                         
