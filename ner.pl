:- include('/home/alejandra/Documents/tareasDCC/eso/traduccion/categorias dependencias').

entidad_intension(Renglon, Entidad, Intension):- re_matchsub('(.+?)\t(.+)\t.*', Renglon, Dict, []),
                                              get_dict(1, Dict, E),
                                              atom_string(Entidad, E),
                                              get_dict(2, Dict, I),
                                              atom_string(Intension, I).

oracion_ner(Linea, Entidades):- atomic_list_concat(Contenido, "\n", Linea),	
                                findall(Entidad:Intension, (member(Renglon,Contenido),
                                                            entidad_intension(Renglon, Entidad, Intension)), Lista),
                                dict_create(Entidades, _, Lista),
                                dict_keys(Entidades, Ents),
                                assert(entidades(Ents)).

id_ner(IdIns, Entidades):- atomic_list_concat(["/home/alejandra/Documents/tareasDCC/eso/",
                                               "traduccion/ner/", IdIns, ".txt"], Direccion),
                                               read_file_to_string(Direccion, Instancia, []),
                                               oracion_ner(Instancia, Entidades).
                                               
id_juiciosEntidades(IdIns, Dict, Deps):- id_ner(IdIns, Entidades),
                                         findall(_, (get_dict(E, Entidades, I), palabra_termino(Dict, Deps, E, S),
                                                     palabra_termino(Dict, Deps, I, P), assert(juicio(S, P, [1,0.9]))), _).


                                                 
                                                                                                    
