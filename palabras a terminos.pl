:- include('./traduccion/ner').

categoria_gramatical(Dict, Palabra, CG):- get_dict(Palabra, Dict, CG).

es_categoria(Dict, Palabra, Categoria):- categoria_gramatical(Dict, Palabra, CG),
                                         call(Categoria, CG).
                                         
propiedad(Dict, PalabraConPos, Termino):- es_categoria(Dict, PalabraConPos, adjetivo),
                                          palabra_pos(PalabraConPos, Palabra, N),
                                          lema(Palabra, Lema),
                                          atomic_list_concat(['[', Lema, '-', N, ']'], Termino).
                                    
propiedad(Dict, PalabraConPos, Termino):- es_categoria(Dict, PalabraConPos, adverbio),
                                          palabra_pos(PalabraConPos, Palabra, N),
                                          lema(Palabra, Lema),
                                          atomic_list_concat(['[', Lema, '-', N, ']'], Termino).                                    
                                    
instancia(Dict, PalabraConPos, Termino):- es_categoria(Dict, PalabraConPos, propio),
                                          entidades(Ents),
                                          member(Ent, Ents),
                                          sub_atom(Ent, _, _, _, PalabraConPos),
                                          atomic_list_concat(['{', Ent, '}'], Termino).                        
                                                                                               
instancia(Dict, Deps, PalabraConPos, Termino):- es_categoria(Dict, PalabraConPos, 'no_propio'),
                                                encontrar_dep_sin_corte(Deps, det, PalabraConPos, DeterminanteConPos),
                                                palabra_pos(DeterminanteConPos, Determinante, _),
                                                palabra_pos(PalabraConPos, Palabra, N),   
                                                atomic_list_concat(['{',Determinante, '-', Palabra, '-', N, '}'], Termino),
                                                lema(Palabra, Lema),
                                                assert(juicio(inheritance(Termino, Lema), [1, 0.9])), !;
                                                es_categoria(Dict, PalabraConPos, 'no_propio'),
                                                encontrar_dep_sin_corte(Deps, 'nmod:poss', PalabraConPos, DeterminanteConPos),
                                                palabra_pos(DeterminanteConPos, Determinante, _),
                                                palabra_pos(PalabraConPos, Palabra, N),   
                                                atomic_list_concat(['{',Determinante, '-', Palabra, '-', N, '}'], Termino),
                                                lema(Palabra, Lema),
                                                assert(juicio(inheritance(Termino, Lema), [1, 0.9])).
                                          
palabra_termino(_, _, Palabra, Termino):- ground(Palabra), Palabra = 'PERSON', Termino = 'person.n.01', !;
                                          ground(Palabra), Palabra = 'ORGANIZATION', Termino = 'organization.n.01', !;
                                          ground(Palabra), Palabra = 'DATE', Termino = 'calendar day.n.01', !;
                                          ground(Palabra), Palabra = 'LOCATION', Termino = 'location.n.01', !.
                                          
palabra_termino(_, _, PalabraPos, Termino):- entidades(Ents),
                                          ground(PalabraPos),
                                          palabra_pos(PalabraPos, Palabra, _),
                                          member(Palabra, Ents),
                                          atomic_list_concat(['{', PalabraPos, '}'], Termino), !.
                                          
palabra_termino(_, _, PPconPos, Termino):- ground(PPconPos), 
                                           palabra_pos(PPconPos, PP, _),
                                           PP = 'I',
                                           atomic_list_concat(['{', PPconPos, '}'], Termino), !; 
                                           ground(PPconPos), 
                                           palabra_pos(PPconPos, PP, Pos),
                                           (PP = 'me'; PP = 'Me'),
                                           atomic_list_concat(['{I-', Pos, '}'], Termino), !;
                                           ground(PPconPos), 
                                           palabra_pos(PPconPos, PP, Pos),
                                           (PP = 'you'; PP = 'You'),
                                           atomic_list_concat(['{you-', Pos, '}'], Termino), !; 
                                           ground(PPconPos), 
                                           palabra_pos(PPconPos, PP, Pos),
                                           (PP = 'she'; PP = 'She'; PP = 'her'; PP = 'Her'),
                                           atomic_list_concat(['{she-', Pos, '}'], Termino), !; 
                                           ground(PPconPos), 
                                           palabra_pos(PPconPos, PP, Pos),
                                           (PP = 'he'; PP = 'He'; PP = 'him'; PP = 'Him'),
                                           atomic_list_concat(['{he-', Pos, '}'], Termino), !;
                                           ground(PPconPos), 
                                           palabra_pos(PPconPos, PP, Pos),
                                           (PP = 'we'; PP = 'We'; PP = 'us'; PP = 'Us'),
                                           atomic_list_concat(['{we-', Pos, '}'], Termino), !;
                                           ground(PPconPos), 
                                           palabra_pos(PPconPos, PP, Pos),
                                           (PP = 'they'; PP = 'They'; PP = 'them'; PP = 'Them'),
                                           atomic_list_concat(['{they-', Pos, '}'], Termino), !.  
                                                     
palabra_termino(Dict, Deps, PalabraConPos, Termino):- ground(PalabraConPos),
                                                propiedad(Dict, PalabraConPos, Termino), !;
                                                ground(PalabraConPos),
                                                instancia(Dict, PalabraConPos, Termino), !;
                                                ground(PalabraConPos),
                                                instancia(Dict, Deps, PalabraConPos, Termino), !;
                                                ground(PalabraConPos),
                                                palabra_pos(PalabraConPos, Palabra, N),
                                                lema(Palabra, Lema),
                                                atomic_list_concat([Lema, '-', N], Termino), !;
                                                ground(PalabraConPos),
                                                lema(PalabraConPos, Termino), !;
                                                Termino = ' '.
                                                
mods(Dict, Deps, Mod1, Mod2, ModT):- (encontrar_dep_sin_corte(Deps, 'nummod', Mod1, Mod2);
                                        encontrar_dep_con_prep(Dict, Deps, 'nmod', Mod1, Mod2, _);                            
                                        encontrar_dep_sin_corte(Deps, 'nmod', Mod1, Mod2);
                                        encontrar_dep_sin_corte(Deps, 'amod', Mod1, Mod2);
                                        encontrar_dep_sin_corte(Deps, 'advmod', Mod1, Mod2)),
                                       (mods(Dict, Deps, Mod2, _, Mod2T),
                                        palabra_pos(Mod1, Mod1P, N),
                                        atomic_list_concat([Mod2T, ' ', Mod1P, '-', N], ModT), !;
                                        palabra_pos(Mod1, Mod1P, N1),
                                        palabra_pos(Mod2, Mod2P, N2),
                                        atomic_list_concat([Mod2P, '-', N2, ' ', Mod1P, '-', N1], ModT)).
                                        
np_mod(Dict, Deps, Core, Terms):- (es_categoria(Dict, Core, 'no_propio');
                                   es_categoria(Dict, Core, 'propio')),
                                  (encontrar_dep_sin_corte(Deps, 'nummod', Core, Mod2);
                                   encontrar_dep_con_prep(Dict, Deps, 'nmod', Core, Mod2, _);                            
                                   encontrar_dep_sin_corte(Deps, 'nmod', Core, Mod2);
                                   encontrar_dep_sin_corte(Deps, 'amod', Core, Mod2);
                                   encontrar_dep_sin_corte(Deps, 'advmod', Core, Mod2)),
                                   mods(Dict, Deps, Mod2, _, Mod2T),
                                   palabra_termino(Dict, Deps, Core, CoreT),
                                   atomic_list_concat(['[', Mod2T, '] & ', CoreT], Terms), !;
                                   (es_categoria(Dict, Core, 'no_propio');
                                    es_categoria(Dict, Core, 'propio')),
                                   (encontrar_dep_sin_corte(Deps, 'nummod', Core, Mod2);
                                    encontrar_dep_sin_corte(Deps, 'amod', Core, Mod2);
                                    encontrar_dep_sin_corte(Deps, 'advmod', Core, Mod2)),
                                   palabra_termino(Dict, Deps, Core, CoreT),
                                   palabra_pos(Mod2, Mod2P, N),
                                   atomic_list_concat(['[', Mod2P, '-', N, '] & ', CoreT], Terms), !;
                                   (es_categoria(Dict, Core, 'no_propio');
                                    es_categoria(Dict, Core, 'propio')),
                                   (encontrar_dep_con_prep(Dict, Deps, 'nmod', Core, Mod2, _);                            
                                    encontrar_dep_sin_corte(Deps, 'nmod', Core, Mod2)),
                                   palabra_termino(Dict, Deps, Core, CoreT),
                                   palabra_pos(Mod2, Mod2P, N),
                                   (es_categoria(Dict, Mod2, 'determinante'),
                                    atomic_list_concat(['{', Mod2P, '-', N, '_', Core, '}'], Terms);
                                    atomic_list_concat([Mod2P, '-', N, '_', CoreT], Terms)). 
                                   
vp_mod(Dict, Deps, Core, Terms):- es_categoria(Dict, Core, 'verbo'),
                                  palabra_termino(Dict, Deps, Core, CoreT),
                                  encontrar_dep_sin_corte(Deps, advmod, Core, Adv),
                                  mods(Dict, Deps, Adv, _, AdvT),
                                  atomic_list_concat([CoreT, ' & [', AdvT, ']'], Terms), !;
                                  es_categoria(Dict, Core, 'verbo'),
                                  palabra_termino(Dict, Deps, Core, CoreT),
                                  encontrar_dep_sin_corte(Deps, advmod, Core, Adv),
                                  palabra_termino(Dict, Deps, Adv, AdvT),
                                  atomic_list_concat([CoreT, ' & ', AdvT], Terms).
                                  
ap_mod(Dict, Deps, Core, Terms):- es_categoria(Dict, Core, 'adjetivo'),
                                  (encontrar_dep_sin_corte(Deps, 'nummod', Core, Mod2);
                                   encontrar_dep_con_prep(Dict, Deps, 'nmod', Core, Mod2, _);                            
                                   encontrar_dep_sin_corte(Deps, 'nmod', Core, Mod2);
                                   encontrar_dep_sin_corte(Deps, 'amod', Core, Mod2);
                                   encontrar_dep_sin_corte(Deps, 'advmod', Core, Mod2)),
                                  mods(Dict, Deps, Mod2, _, Mod2T),
                                  palabra_termino(Dict, Deps, Core, CoreT),
                                  atomic_list_concat(['[', Mod2T, '] & ', CoreT], Terms), !;
                                  es_categoria(Dict, Core, 'adjetivo'),
                                  (encontrar_dep_sin_corte(Deps, 'nummod', Core, Mod2);
                                   encontrar_dep_con_prep(Dict, Deps, 'nmod', Core, Mod2, _);                            
                                   encontrar_dep_sin_corte(Deps, 'nmod', Core, Mod2);
                                   encontrar_dep_sin_corte(Deps, 'amod', Core, Mod2);
                                   encontrar_dep_sin_corte(Deps, 'advmod', Core, Mod2)),
                                  palabra_pos(Mod2, Mod2P, N),
                                  atomic_list_concat(['[', Mod2P, '-', N, ' ', Core, ']'], Terms).             
                                        
phrase(Dict, Deps, Core, Terms):- ground(Core),
                                  np_mod(Dict, Deps, Core, Terms), !;
                                  ground(Core),
                                  vp_mod(Dict, Deps, Core, Terms), !;
                                  ground(Core),
                                  ap_mod(Dict, Deps, Core, Terms), !;
                                  palabra_termino(Dict, Deps, Core, Terms).
                                  
                                                                                                       
                                                                                                           
