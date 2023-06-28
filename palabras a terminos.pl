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
                                          ground(Palabra), Palabra = 'LOCATION', Termino = 'location.n.01', !.
                                          
palabra_termino(_, _, Palabra, Termino):- entidades(Ents),
                                          ground(Palabra),
                                          member(Palabra, Ents),
                                          atomic_list_concat(['{', Palabra, '}'], Termino), !.
                                          
palabra_termino(Dict, Deps, PalabraConPos, Termino):- not(instancia(Dict, Deps, PalabraConPos, _)),
                                                      encontrar_dep_sin_corte(Deps, amod, PalabraConPos, AdjetivoConPos),
                                                      propiedad(Dict, AdjetivoConPos, AdjetivoT),
                                                      palabra_pos(PalabraConPos, Palabra, N),
                                                      lema(Palabra, Lema),   
                                                      atomic_list_concat([Lema, '-', N, ' & ', AdjetivoT], Termino), !.
                                                     
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
                                                Termino = ' '.
                                                                                                       
                                                                                                           
