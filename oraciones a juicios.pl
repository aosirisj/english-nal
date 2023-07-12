:- include('./traduccion/palabras a terminos').
                                 
np_advmod(Dict, Deps, Predicado, ModT):- encontrar_dep_sin_corte(Deps, 'obl:npmod', Predicado, Sustantivo),
                                         mods(Dict, Deps, Sustantivo, _, ModT), !;
                                         encontrar_dep_sin_corte(Deps, 'obl:npmod', Predicado, Sustantivo),
                                         palabra_termino(Dict, Deps, Sustantivo, ModT).
                                         
advcl(Dict, Deps, Accion, J):- %comparativo, checar dependencias
                               encontrar_dep_sin_corte(Deps, advcl, AdvMod, Advcl),
                               es_categoria(Dict, Advcl, modal),
                               encontrar_dep_sin_corte(Deps, advmod, AdvMod, As),
                               palabra_pos(As, 'as', Pos),
                               atom_number(Pos, N),
                               N2 is N + 2,
                               atom_number(Pos2, N2),
                               palabra_pos(_, 'as', Pos2),
                               (ccomp_juicio_nocopular(Dict, Deps, Accion, SujT);
				ccomp_juicio_copular(Dict, Deps, Accion, SujT);
				xcomp_juicio_nocopular(Dict, Deps, Accion, SujT);
				xcomp_juicio_copular(Dict, Deps, Accion, SujT);
				obl_loc_temp(Dict, Deps, Accion, SujT), !;
				activa_a_juicio(Dict, Deps, Accion, SujT);
                                pasiva_a_juicio(Dict, Deps, Accion, SujT);
                                copular(Dict, Deps, Accion, SujT);
                                expletivo(Dict, Deps, Accion, SujT)),
                               encontrar_dep(Deps, nsubj, Advcl, Subj2),
                               SujT = inheritance([S, O, I], Verb),
                               atomic_list_concat([V|_], ' &', Verb),
                               phrase(Dict, Deps, Subj2, Subj2T),
                               Suj2T = inheritance([S, O, I], V),
                               ObjT = inheritance([Subj2T, O, I], V),
                               atomic_list_concat(['as_', AdvMod], PredicadoT),
                               J = inheritance([Suj2T, ObjT], PredicadoT), !;
                               %comparativo con distintos objetos, checar dependencias
                               encontrar_dep_sin_corte(Deps, advcl, AdvMod, Advcl),
                               es_categoria(Dict, Advcl, verbo),
                               encontrar_dep_sin_corte(Deps, advmod, AdvMod, As),
                               palabra_pos(As, 'as', Pos),
                               atom_number(Pos, N),
                               N2 is N + 2,
                               atom_number(Pos2, N2),
                               palabra_pos(_, 'as', Pos2),
                               (ccomp_juicio_nocopular(Dict, Deps, Accion, SujT);
				ccomp_juicio_copular(Dict, Deps, Accion, SujT);
				xcomp_juicio_nocopular(Dict, Deps, Accion, SujT);
				xcomp_juicio_copular(Dict, Deps, Accion, SujT);
				obl_loc_temp(Dict, Deps, Accion, SujT), !;
				activa_a_juicio(Dict, Deps, Accion, SujT);
                                pasiva_a_juicio(Dict, Deps, Accion, SujT);
                                copular(Dict, Deps, Accion, SujT);
                                expletivo(Dict, Deps, Accion, SujT)),
                               (ccomp_juicio_nocopular(Dict, Deps, Advcl, ObjT);
		                ccomp_juicio_copular(Dict, Deps, Advcl, ObjT);
				xcomp_juicio_nocopular(Dict, Deps, Advcl, ObjT);
				xcomp_juicio_copular(Dict, Deps, Advcl, ObjT);
				obl_loc_temp(Dict, Deps, Advcl, ObjT), !;
				activa_a_juicio(Dict, Deps, Advcl, ObjT);
                                pasiva_a_juicio(Dict, Deps, Advcl, ObjT);
                                copular(Dict, Deps, Advcl, ObjT);
                                expletivo(Dict, Deps, Advcl, ObjT)),                            
                               SujT = inheritance([S, O, I], Verb),
                               ObjT = inheritance([S2, O2, I2], Verb2),
                               atomic_list_concat([V|_], ' &', Verb),
                               atomic_list_concat([V2|_], ' &', Verb2),
                               Suj2T = inheritance([S, O, I], V),
                               Obj2T = inheritance([S2, O2, I2], V2),
                               atomic_list_concat(['as_', AdvMod], PredicadoT),
                               J = inheritance([Suj2T, Obj2T], PredicadoT).
                                                              

advcl(Dict, Deps, Accion, J):- encontrar_dep_sin_corte(Deps, advcl, Accion, Advcl),
                                                                 %not(encontrar_dep_sin_corte(Deps, ccomp, Accion, _)),
								 %not(encontrar_dep_sin_corte(Deps, xcomp, Accion, _)),
						              (ccomp_juicio_nocopular(Dict, Deps, Accion, SujT);
							       ccomp_juicio_copular(Dict, Deps, Accion, SujT);
							       xcomp_juicio_nocopular(Dict, Deps, Accion, SujT);
							       xcomp_juicio_copular(Dict, Deps, Accion, SujT);
							       obl_loc_temp(Dict, Deps, Accion, SujT), !;
							       activa_a_juicio(Dict, Deps, Accion, SujT);
                                                               pasiva_a_juicio(Dict, Deps, Accion, SujT);
                                                               copular(Dict, Deps, Accion, SujT);
                                                               expletivo(Dict, Deps, Accion, SujT)),
                                                              (ccomp_juicio_nocopular(Dict, Deps, Advcl, ObjT);
							       ccomp_juicio_copular(Dict, Deps, Advcl, ObjT);
							       xcomp_juicio_nocopular(Dict, Deps, Advcl, ObjT);
							       xcomp_juicio_copular(Dict, Deps, Advcl, ObjT);
							       obl_loc_temp(Dict, Deps, Advcl, ObjT), !;
							       activa_a_juicio(Dict, Deps, Advcl, ObjT);
                                                               pasiva_a_juicio(Dict, Deps, Advcl, ObjT);
                                                               copular(Dict, Deps, Advcl, ObjT);
                                                               expletivo(Dict, Deps, Advcl, ObjT)),
                                                              (encontrar_dep_sin_corte(Deps, advmod, Advcl, ModPos);
                                                               encontrar_dep_sin_corte(Deps, mark, Advcl, ModPos)),
                                                              palabra_pos(ModPos, Mod, _),
                                                              ((encontrar_dep_sin_corte(Deps, fixed, ModPos, If),
                                                                palabra_pos(ModPos, 'as', _),
                                                                palabra_pos(If, 'if', _),
                                                                J = inheritance([SujT, ObjT], how)), !;
                                                               (encontrar_dep_sin_corte(Deps, fixed, ModPos, Order),
                                                                (palabra_pos(Order, 'order', _), !;
                                                                 palabra_pos(Order, 'case', _)),
                                                                J = inheritance([SujT, ObjT], purpose)), !;
                                                               (advcl_place(Mod),
                                                                J = inheritance([SujT, ObjT], where)), !;
                                                               (advcl_time(Mod),
                                                                J = inheritance([SujT, ObjT], when)), !;
                                                               (advcl_concession(Mod),
                                                                J = inheritance([SujT, ObjT], but)), !;
                                                               (advcl_purpose(Mod),
                                                                J = inheritance([SujT, ObjT], purpose)), !;
                                                               (advcl_reason(Mod),
                                                                J = inheritance([SujT, ObjT], reason)), !;
                                                               (advcl_manner(Mod),
                                                                J = inheritance([SujT, ObjT], how)), !;
                                                               J = implication(ObjT, SujT)).
                                                               
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
                                                                      obl_loc_temp(Dict, Deps, Accion, SujT), !;
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
                                                                      obl_loc_temp(Dict, Deps, Sub, SujT), !;
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
                                                                      obl_loc_temp(Dict, Deps, Accion, SujT), !;
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
                                                                      obl_loc_temp(Dict, Deps, Sub, SujT), !;
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
								     
obl_loc_temp(Dict, Deps, Accion, inheritance(SujetoT, PredicadoT)):- (encontrar_dep_sin_corte(Deps, obl, Accion, ModObl);
                                                                      encontrar_dep_con_prep(Dict, Deps, obl, Accion, ModObl, _)),
                                                                     not(encontrar_dep_sin_corte(Deps, ccomp, Accion, _)),
								     not(encontrar_dep_sin_corte(Deps, xcomp, Accion, _)),
								     %not(encontrar_dep_sin_corte(Deps, cop, Accion, _)),
								     %es_categoria(Dict, Accion, verbo),
								     palabra_pos(Accion, Pred, _),
								     not(tobe(Pred)),
								     palabra_pos(ModObl, ModOblP, _),
								     localization(ModOblP),
								     (activa_a_juicio(Dict, Deps, Accion, SujT), !;
								      pasiva_a_juicio(Dict, Deps, Accion, SujT), !;
								      copular(Dict, Deps, Accion, SujT)),
								     phrase(Dict, Deps, ModObl, ObjT),
								     SujetoT = [SujT, ObjT],
								     PredicadoT = where, !;
								     (encontrar_dep_sin_corte(Deps, obl, Accion, ModObl);
                                                                      encontrar_dep_con_prep(Dict, Deps, obl, Accion, ModObl, _)),
                                                                     not(encontrar_dep_sin_corte(Deps, ccomp, Accion, _)),
								     not(encontrar_dep_sin_corte(Deps, xcomp, Accion, _)),
								     %not(encontrar_dep_sin_corte(Deps, cop, Accion, _)),
								     %es_categoria(Dict, Accion, verbo),
								     palabra_pos(Accion, Pred, _),
								     not(tobe(Pred)),
								     palabra_pos(ModObl, ModOblP, _),
								     time(ModOblP),
								     (activa_a_juicio(Dict, Deps, Accion, SujT), !;
								      pasiva_a_juicio(Dict, Deps, Accion, SujT), !;
								      copular(Dict, Deps, Accion, SujT)),
								     phrase(Dict, Deps, ModObl, ObjT),
								     SujetoT = [SujT, ObjT],
								     PredicadoT = when, !.
								                                                                          
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
                                                                     (encontrar_dep_sin_corte(Deps, 'obl:to', Accion, Iobj),
                                                                      palabra_pos(Iobj, IObjSinPos, _),
                                                                      not(localization(IObjSinPos)), !;
                                                                      encontrar_dep(Deps, iobj, Accion, Iobj)),
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
				                              phrase(Dict, Deps, Predicado, PredicadoT),
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
				                              phrase(Dict, Deps, Predicado, PredicadoT),
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
							     %location
							     encontrar_dep_sin_corte(Deps, cop, Predicado, _),
							     encontrar_dep_sin_corte(Deps, case, Predicado, _),
							     not(encontrar_dep_sin_corte(Deps, ccomp, Predicado, _)),
							     not(encontrar_dep_sin_corte(Deps, xcomp, Predicado, _)),
							     palabra_pos(Predicado, Pred, _),
							     localization(Pred),
							     (encontrar_csubj(Dict, Deps, Predicado, SujetoT);
							      encontrar_nsubj(Deps, Predicado, Suj),
							      phrase(Dict, Deps, Suj, SujT)),
							     phrase(Dict, Deps, Predicado, ObjT),
							     SujetoT = [SujT, ObjT],
							     PredicadoT = where, !;
							     %otro
							     encontrar_dep_sin_corte(Deps, cop, Predicado, _),
							     not(encontrar_dep_sin_corte(Deps, ccomp, Predicado, _)),
							     not(encontrar_dep_sin_corte(Deps, xcomp, Predicado, _)),
							     (encontrar_csubj(Dict, Deps, Predicado, SujetoT);
							      encontrar_nsubj(Deps, Predicado, Suj),
							      phrase(Dict, Deps, Suj, SujetoT)),
							     phrase(Dict, Deps, Predicado, PredicadoT).
                                                               
adjetivo_a_juicio(Dict, Deps, juicio(inheritance(SujetoT, PredicadoT), [1,0.9])):- encontrar_dep_sin_corte(Deps, amod, Sujeto, Predicado),
                                                                      not(es_categoria(Dict, Predicado, superlativo)),
                                                                      not(es_categoria(Dict, Predicado, comparativo)),
                                                                      (mods(Dict, Deps, Predicado, _, ModT),
                                                                       atomic_list_concat(['[', ModT, ']'], PredicadoT);
                                                                      phrase(Dict, Deps, Predicado, PredicadoT)),
                                                                      phrase(Dict, Deps, Sujeto, SujetoT),
                                                                      sub_atom(SujetoT, 0, 1, _, '{').
                                                                      
expletivo(Dict, Deps, Predicado, inheritance(SujetoT, PredicadoT)):- encontrar_dep_sin_corte(Deps, expl, Predicado, _),
                                                            palabra_pos(Predicado, Pred, _),
                                                            tobe(Pred),
                                                            encontrar_nsubj(Deps, Predicado, Sujeto),
                                                            encontrar_dep_con_prep(Dict, Deps, obl, Predicado, ModPos, _),
                                                            palabra_pos(ModPos, Mod, _),
                                                            localization(Mod),
                                                            phrase(Dict, Deps, Sujeto, SujT), 
                                                            phrase(Dict, Deps, ModPos, ObjT), 
                                                            SujetoT = [SujT, ObjT],
                                                            PredicadoT = where, !;
                                                            encontrar_dep_sin_corte(Deps, expl, Predicado, _),
                                                            palabra_pos(Predicado, Pred, _),
                                                            tobe(Pred),
                                                            encontrar_nsubj(Deps, Predicado, Sujeto),
                                                            encontrar_dep_con_prep(Dict, Deps, nmod, Sujeto, ModPos, _),
                                                            palabra_pos(ModPos, Mod, _),
                                                            localization(Mod),
                                                            palabra_termino(Dict, Deps, Sujeto, SujT), 
                                                            phrase(Dict, Deps, ModPos, ObjT), 
                                                            SujetoT = [SujT, ObjT],
                                                            PredicadoT = where, !;
                                                            encontrar_dep_sin_corte(Deps, expl, Predicado, _),
                                                            palabra_pos(Predicado, Pred, _),
                                                            tobe(Pred),
                                                            encontrar_nsubj(Deps, Predicado, Sujeto),
                                                            phrase(Dict, Deps, Sujeto, PredicadoT).
                                                            
                                                                      
oracion_a_juicio(Dict, Deps, juicio(Herencia, [1,0.9])):- member(Root, Deps),
							  tripleta(Root, _, 0, root, Raiz, PosR),
							  atomic_list_concat([Raiz, '-', PosR], Cabeza),
							  (advcl(Dict, Deps, Cabeza, Herencia), !;
							   ccomp_juicio_nocopular(Dict, Deps, Cabeza, Herencia), !;
							   ccomp_juicio_copular(Dict, Deps, Cabeza, Herencia), !;
							   xcomp_juicio_nocopular(Dict, Deps, Cabeza, Herencia), !;
							   xcomp_juicio_copular(Dict, Deps, Cabeza, Herencia), !;
							   obl_loc_temp(Dict, Deps, Cabeza, Herencia), !;
							   activa_a_juicio(Dict, Deps, Cabeza, Herencia), !;
                                                           pasiva_a_juicio(Dict, Deps, Cabeza, Herencia), !;
                                                           copular(Dict, Deps, Cabeza, Herencia), !;
                                                           expletivo(Dict, Deps, Cabeza, Herencia)).
                                                           
appos(Dict, Deps, inheritance(SujetoT, PredicadoT)):- encontrar_dep_sin_corte(Deps, appos, Cabeza, Appos),
                                                              phrase(Dict, Deps, Cabeza, PredicadoT),
                                                              phrase(Dict, Deps, Appos, SujetoT).
                                                              
superlativo_obl(Dict, Deps, inheritance(_, PredicadoT)):- (es_categoria(Dict, Predicado, superlativo),
                                                                 encontrar_dep_sin_corte(Deps, obl, Predicado, Obl),
                                                                 phrase(Dict, Deps, Obl, PredicadoT));
                                                                (es_categoria(Dict, Predicado, superlativo),
                                                                 encontrar_dep_con_prep(Dict, Deps, nmod, Predicado, Obl, _),
                                                                 palabra_termino(Dict, Deps, Obl, PredicadoT)).
                                                                 
acl(Dict, Deps, inheritance(SujetoT, PredicadoT)):- (encontrar_dep_sin_corte(Deps, acl, Nominal, Cabeza), !;
                                                     encontrar_dep_sin_corte(Deps, 'acl:relcl', Nominal, Cabeza)),
                                                    phrase(Dict, Deps, Nominal, NominalT),
                                                    (%advcl(Dict, Deps, Cabeza, Herencia), !;
					             %ccomp_juicio_nocopular(Dict, Deps, Cabeza, Herencia), !;
						     %ccomp_juicio_copular(Dict, Deps, Cabeza, Herencia), !;
						     %xcomp_juicio_nocopular(Dict, Deps, Cabeza, Herencia), !;
						     %xcomp_juicio_copular(Dict, Deps, Cabeza, Herencia), !;
						     %obl_loc_temp(Dict, Deps, Cabeza, Herencia), !;
						     (activa_a_juicio(Dict, Deps, Cabeza, inheritance(Sujeto, PredicadoT)), !;
						      pasiva_a_juicio(Dict, Deps, Cabeza, inheritance(Sujeto, PredicadoT))),
						     Sujeto = [Suj, Obj, Iobj], 
						     (Suj = ' ',
						      SujetoT = [NominalT, Obj, Iobj], !;
						      SujetoT = [Suj, NominalT, Iobj]), !;
                                                     copular(Dict, Deps, Cabeza, inheritance(Sujeto, PredicadoT)), 
                                                     Sujeto = [Suj, Obj], 
						     (Suj = ' ',
						      SujetoT = [NominalT, Obj], !;
						      SujetoT = [Suj, NominalT]), !;
						     copular(Dict, Deps, Cabeza, inheritance(Sujeto, PredicadoT)), 
                                                     not(ground(Sujeto)),
						     SujetoT = NominalT).%, !;
                                                     %expletivo(Dict, Deps, Cabeza, Herencia)).
                                                     
                                                                 
aditional_judgements(Dict, Deps, Juicios):- findall(Appos, appos(Dict, Deps, Appos), JuiciosAppos),
                                            findall(Obl, superlativo_obl(Dict, Deps, Obl), JuiciosObls),
                                            findall(Acl, acl(Dict, Deps, Acl), JuiciosAcl),
                                            append([JuiciosAppos, JuiciosObls, JuiciosAcl], Juicios).

idinstancia_a_juicios(IdIns, Juicios):- encontrar_CGs_dependencias_id(IdIns, Dict, Deps),
                                        findall(Propiedad, (adjetivo_a_juicio(Dict, Deps, Propiedad)), Adjs),
                                        findall(Juicio, oracion_a_juicio(Dict, Deps, Juicio), Oraciones),
                                        append(Adjs, Oraciones, JuiciosMid),
                                        aditional_judgements(Dict, Deps, Aditional),
                                        append(JuiciosMid, Aditional, Juicios),
                                        maplist(assert, Juicios).
                                                         
                                                         
                                                         
                                                         
