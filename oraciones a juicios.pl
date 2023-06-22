:- include('/home/alejandra/Documents/tareasDCC/eso/traduccion/palabras a terminos').

encontrar_csubj(Dict, Deps, Accion, SujT):- encontrar_dep_sin_corte(Deps, csubj, Accion, Sub),
                                      (ccomp_juicio_nocopular(Dict, Deps, Sub, SujT);
                                       ccomp_juicio_copular(Dict, Deps, Sub, SujT);
                                       xcomp_juicio_nocopular(Dict, Deps, Sub, SujT);
                                       xcomp_juicio_copular(Dict, Deps, Sub, SujT);
                                       activa_a_juicio(Dict, Deps, Sub, SujT);
                                       pasiva_a_juicio(Dict, Deps, Sub, SujT);
                                       copular(Dict, Deps, Sub, SujT)).
                                       
encontrar_csubjp(Dict, Deps, Accion, SujT):- encontrar_dep_sin_corte(Deps, 'csubj:pass', Accion, Sub),
                                      (ccomp_juicio_nocopular(Dict, Deps, Sub, SujT);
                                       ccomp_juicio_copular(Dict, Deps, Sub, SujT);
                                       xcomp_juicio_nocopular(Dict, Deps, Sub, SujT);
                                       xcomp_juicio_copular(Dict, Deps, Sub, SujT);
                                       activa_a_juicio(Dict, Deps, Sub, SujT);
                                       pasiva_a_juicio(Dict, Deps, Sub, SujT);
                                       copular(Dict, Deps, Sub, SujT)).

ccomp_juicio_nocopular(Dict, Deps, Accion, inheritance(SujetoT, PredicadoT)):- not(encontrar_dep_sin_corte(Deps, cop, Accion, _)),
								     es_categoria(Dict, Accion, verbo),
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
								     palabra_termino(Dict, Deps, Suj, SujT)),
                                                                     %Analisis objeto indirecto atomico
                                                                     (encontrar_dep_sin_corte(Deps, iobj, Accion, Iobj);
                                                                      encontrar_dep(Deps, 'obl:to', Accion, Iobj)),
                                                                     palabra_termino(Dict, Deps, Iobj, IobjT),
                                                                     %Analisis predicado (herencia)
                                                                     palabra_termino(Dict, Deps, Accion, AccionT),
                                                                     (encontrar_dep_sin_corte(Deps, advmod, Accion, Adv) -> 
                                                                      palabra_termino(Dict, Deps, Adv, AdvT),
                                                                      atomic_list_concat([AccionT, ' & ', AdvT], PredicadoT);
                                                                      PredicadoT = AccionT),
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
								     palabra_termino(Dict, Deps, Suj, SujT)),
                                                                     %Analisis predicado (herencia)
                                                                     palabra_termino(Dict, Deps, Predicado, PredicadoT),
                                                                     %Analisis sujeto herencia
                                                                     SujetoT = [SujT, ObjT].
                                                                     
xcomp_juicio_nocopular(Dict, Deps, Accion, inheritance(SujetoT, PredicadoT)):- not(encontrar_dep_sin_corte(Deps, cop, Accion, _)),
								     es_categoria(Dict, Accion, verbo),
								     %Analisis objeto ccomp
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
								     palabra_termino(Dict, Deps, Suj, SujT)),
                                                                     %Analisis objeto indirecto atomico
                                                                     (encontrar_dep_sin_corte(Deps, iobj, Accion, Iobj);
                                                                      encontrar_dep(Deps, 'obl:to', Accion, Iobj)),
                                                                     palabra_termino(Dict, Deps, Iobj, IobjT),
                                                                     %Analisis predicado (herencia)
                                                                     palabra_termino(Dict, Deps, Accion, AccionT),
                                                                     (encontrar_dep_sin_corte(Deps, advmod, Accion, Adv) -> 
                                                                      palabra_termino(Dict, Deps, Adv, AdvT),
                                                                      atomic_list_concat([AccionT, ' & ', AdvT], PredicadoT);
                                                                      PredicadoT = AccionT),
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
								     palabra_termino(Dict, Deps, Suj, SujT)),
                                                                     %Analisis predicado (herencia)
                                                                     palabra_termino(Dict, Deps, Predicado, PredicadoT),
                                                                     %Analisis sujeto herencia
                                                                     SujetoT = [SujT, ObjT].
                                                                     
analisis_xcomp_nocopular(Dict, Deps, Sub, inheritance(SujetoT, PredicadoT)):- es_categoria(Dict, Sub, verbo),
								     not(encontrar_dep_sin_corte(Deps, cop, Sub, _)),
								     encontrar_dep_sin_corte(Deps, xcomp, Accion, Sub),
								     %Analisis sujeto atomico
								     (encontrar_dep_sin_corte(Deps, obj, Accion, Suj) -> 
                                                                      palabra_termino(Dict, Deps, Suj, SujT);
                                                                      encontrar_csubj(Dict, Deps, Accion, SujT);
								      encontrar_nsubj(Deps, Accion, Suj),
								      palabra_termino(Dict, Deps, Suj, SujT)),
                                                                      %Analisis objeto atomico
								     encontrar_dep(Deps, obj, Sub, Obj),
                                                                     palabra_termino(Dict, Deps, Obj, ObjT),
								     %Analisis objeto indirecto atomico
                                                                     (encontrar_dep_sin_corte(Deps, iobj, Sub, Iobj);
                                                                      encontrar_dep(Deps, 'obl:to', Sub, Iobj)),
                                                                     palabra_termino(Dict, Deps, Iobj, IobjT),
                                                                     %Analisis predicado atomico (herencia)
                                                                     palabra_termino(Dict, Deps, Sub, SubT),
                                                                     (encontrar_dep_sin_corte(Deps, advmod, Sub, Adv) -> 
                                                                      palabra_termino(Dict, Deps, Adv, AdvT),
                                                                      atomic_list_concat([SubT, ' & ', AdvT], PredicadoT);
                                                                      PredicadoT = SubT),
                                                                     %Analisis sujeto herencia
                                                                     SujetoT = [SujT, ObjT, IobjT].
                                                                     
analisis_xcomp_copular(Dict, Deps, Sub, inheritance(SujetoT, PredicadoT)):- encontrar_dep_sin_corte(Deps, cop, Sub, _),
								     encontrar_dep_sin_corte(Deps, xcomp, Accion, Sub),
								     %Analisis sujeto atomico
								     (encontrar_dep_sin_corte(Deps, obj, Accion, Suj) -> 
                                                                      palabra_termino(Dict, Deps, Suj, SujetoT);
                                                                     (encontrar_csubj(Dict, Deps, Accion, SujetoT);
								      encontrar_dep(Deps, nsubj, Accion, Suj),
								      palabra_termino(Dict, Deps, Suj, SujetoT))),
								     %Analisis predicado
								     palabra_termino(Dict, Deps, Sub, PredicadoT).
                                                                     
activa_a_juicio(Dict, Deps, Accion, inheritance(SujetoT, PredicadoT)):- not(encontrar_dep_sin_corte(Deps, ccomp, Accion, _)),
									not(encontrar_dep_sin_corte(Deps, xcomp, Accion, _)),
								     not(encontrar_dep_sin_corte(Deps, cop, Accion, _)),
								     es_categoria(Dict, Accion, verbo),
								     %Analisis sujeto atomico
								     (encontrar_csubj(Dict, Deps, Accion, SujT);
								      not(encontrar_csubj(Dict, Deps, Accion, SujT)),
								      encontrar_dep(Deps, Accion, nsubj, Suj),
								      palabra_termino(Dict, Deps, Suj, SujT)),
								     %Analisis objeto atomico
								     encontrar_dep(Deps, obj, Accion, Obj),
                                                                     palabra_termino(Dict, Deps, Obj, ObjT),
                                                                     %Analisis objeto indirecto atomico
                                                                     (encontrar_dep_sin_corte(Deps, iobj, Accion, Iobj);
                                                                      encontrar_dep(Deps, 'obl:to', Accion, Iobj)),
                                                                     palabra_termino(Dict, Deps, Iobj, IobjT),
                                                                     %Analisis predicado atomico (herencia)
                                                                     palabra_termino(Dict, Deps, Accion, AccionT),
                                                                     (encontrar_dep_sin_corte(Deps, advmod, Accion, Adv) -> 
                                                                      palabra_termino(Dict, Deps, Adv, AdvT),
                                                                      atomic_list_concat([AccionT, ' & ', AdvT], PredicadoT);
                                                                      PredicadoT = AccionT),
                                                                     %Analisis sujeto herencia
                                                                     SujetoT = [SujT, ObjT, IobjT].%, !;
                                                                     %encontrar_nsubj(Deps, Accion, Suj),
                                                                     %not(encontrar_dep_sin_corte(Deps, cop, Accion, _)),
                                                                     %encontrar_dep(Deps, obj, Accion, Obj),
                                                                     %encontrar_dep(Deps, 'obl:to', Accion, Iobj),
                                                                     %palabra_termino(Dict, Deps, Accion, AccionT),
                                                                     %palabra_termino(Dict, Deps, Suj, SujT),
                                                                     %palabra_termino(Dict, Deps, Obj, ObjT),
                                                                     %palabra_termino(Dict, Deps, Iobj, IobjT),
                                                                     %SujetoT = [SujT, ObjT, IobjT],
                                                                     %(encontrar_dep_sin_corte(Deps, advmod, Accion, Adv) -> 
                                                                     % palabra_termino(Dict, Deps, Adv, AdvT),
                                                                     % atomic_list_concat([AccionT, ' & ', AdvT], PredicadoT);
                                                                     % PredicadoT = AccionT).
                                                                           
pasiva_a_juicio(Dict, Deps, Accion, inheritance(SujetoT, PredicadoT)):- not(encontrar_dep_sin_corte(Deps, ccomp, Accion, _)),
									not(encontrar_dep_sin_corte(Deps, xcomp, Accion, _)),
									es_categoria(Dict, Accion, verbo),
								     %Analisis objeto
								     (encontrar_csubjp(Dict, Deps, Accion, ObjT);
								      encontrar_nsubjp(Deps, Accion, Obj),
                                                                      palabra_termino(Dict, Deps, Obj, ObjT)),
                                                                     %Analisis recipiente
                                                                     encontrar_dep(Deps, 'obl:to', Accion, Iobj),
                                                                     palabra_termino(Dict, Deps, Iobj, IobjT),
                                                                     %Analisis agente
                                                                     encontrar_dep(Deps, 'obl:by', Accion, Suj),
                                                                     palabra_termino(Dict, Deps, Suj, SujT),
                                                                     %Analisis sujeto de herencia
                                                                     SujetoT = [SujT, ObjT, IobjT],
                                                                     %Analisis predicado de herencia
                                                                     palabra_termino(Dict, Deps, Accion, AccionT),
                                                                     (encontrar_dep_sin_corte(Deps, advmod, Accion, Adv) -> 
                                                                      palabra_termino(Dict, Deps, Adv, AdvT),
                                                                      atomic_list_concat([AccionT, ' & ', AdvT], PredicadoT);
                                                                      PredicadoT = AccionT).
                                                                       
copular(Dict, Deps, Predicado, inheritance(SujetoT, PredicadoT)):- encontrar_dep_sin_corte(Deps, cop, Predicado, _),
							     not(encontrar_dep_sin_corte(Deps, ccomp, Predicado, _)),
							     not(encontrar_dep_sin_corte(Deps, xcomp, Predicado, _)),
                                                             palabra_termino(Dict, Deps, Predicado, PredicadoT),
                                                             (encontrar_csubj(Dict, Deps, Predicado, SujetoT);
							      encontrar_nsubj(Deps, Predicado, Suj),
							      palabra_termino(Dict, Deps, Suj, SujetoT)).
                                                             %Falta agregar caso en el que Predicado es clausula
                                                               
adjetivo_a_juicio(Dict, Deps, juicio(inheritance(SujetoT, PredicadoT), [1,0.9])):- encontrar_dep_sin_corte(Deps, amod, Sujeto, Predicado),
                                                                      not(es_categoria(Dict, Predicado, superlativo)),
                                                                      palabra_termino(Dict, Deps, Predicado, PredicadoT),
                                                                      palabra_termino(Dict, Deps, Sujeto, SujetoT),
                                                                      sub_atom(SujetoT, 0, 1, _, '{').
                                                                      
oracion_a_juicio(Dict, Deps, juicio(Herencia, [1,0.9])):- member(Root, Deps),
									tripleta(Root, _, 0, root, Raiz, PosR),
									atomic_list_concat([Raiz, '-', PosR], Cabeza),
									(ccomp_juicio_nocopular(Dict, Deps, Cabeza, Herencia);
									 ccomp_juicio_copular(Dict, Deps, Cabeza, Herencia);
									 xcomp_juicio_nocopular(Dict, Deps, Cabeza, Herencia);
									 xcomp_juicio_copular(Dict, Deps, Cabeza, Herencia);
									 activa_a_juicio(Dict, Deps, Cabeza, Herencia);
                                                                         pasiva_a_juicio(Dict, Deps, Cabeza, Herencia);
                                                                         copular(Dict, Deps, Cabeza, Herencia)).

idinstancia_a_juicios(IdIns, Juicios):- encontrar_CGs_dependencias_id(IdIns, Dict, Deps),
                                        findall(Propiedad, (adjetivo_a_juicio(Dict, Deps, Propiedad)), Adjs),
                                        findall(Juicio, oracion_a_juicio(Dict, Deps, Juicio), Oraciones),
                                        append(Adjs, Oraciones, Juicios),
                                        maplist(assert, Juicios).
                                                         
                                                         
                                                         
                                                         
