:- include('/home/alejandra/Documents/tareasDCC/eso/traduccion/ner').

categoria_gramatical(Dict, Palabra, CG):- get_dict(Palabra, Dict, CG).

es_categoria(Dict, Palabra, Categoria):- categoria_gramatical(Dict, Palabra, CG),
                                         call(Categoria, CG).
                                         
propiedad(Dict, Palabra, Termino):- es_categoria(Dict, Palabra, adjetivo),
                                    lema(Palabra, Lema),
                                    atomic_list_concat(['[', Lema, ']'], Termino).
                                    
propiedad(Dict, Palabra, Termino):- es_categoria(Dict, Palabra, adverbio),
                                    lema(Palabra, Lema),
                                    atomic_list_concat(['[', Lema, ']'], Termino).                                    
                                    
instancia(Dict, Palabra, Termino):- es_categoria(Dict, Palabra, propio),
                                    entidades(Ents),
                                    member(Ent, Ents),
                                    sub_atom(Ent, _, _, _, Palabra),
                                    atomic_list_concat(['{', Ent, '}'], Termino).                        
                                                                                               
instancia(Dict, Deps, Palabra, Termino):- es_categoria(Dict, Palabra, 'no_propio'),
                                          encontrar_dep_sin_corte(Deps, det, Palabra, Determinante),   
                                          atomic_list_concat(['{',Determinante, '-', Palabra, '}'], Termino),
                                          lema(Palabra, Lema),
                                          assert(juicio(Termino, Lema, [1, 0.9])), !;
                                          es_categoria(Dict, Palabra, 'no_propio'),
                                          encontrar_dep_sin_corte(Deps, 'amod:poss', Palabra, Determinante),   
                                          atomic_list_concat(['{',Determinante, '-', Palabra, '}'], Termino),
                                          lema(Palabra, Lema),
                                          assert(juicio(Termino, Lema, [1, 0.9])).
                                          
palabra_termino(_, _, Palabra, Termino):- ground(Palabra), Palabra = 'PERSON', Termino = 'person.n.1', !;
                                          ground(Palabra), Palabra = 'ORGANIZATION', Termino = 'organization.n.1', !;
                                          ground(Palabra), Palabra = 'LOCATION', Termino = 'location;.n.1', !.
                                          
palabra_termino(_, _, Palabra, Termino):- entidades(Ents),
                                          ground(Palabra),
                                          member(Palabra, Ents),
                                          atomic_list_concat(['{', Palabra, '}'], Termino), !.                                
                                                         
palabra_termino(Dict, Deps, Palabra, Termino):- ground(Palabra),
                                                propiedad(Dict, Palabra, Termino), !;
                                                ground(Palabra),
                                                instancia(Dict, Palabra, Termino), !;
                                                ground(Palabra),
                                                instancia(Dict, Deps, Palabra, Termino), !;
                                                ground(Palabra),
                                                lema(Palabra, Termino), !;
                                                Termino = ' '.
                                                                                                       
                                                                                                           
