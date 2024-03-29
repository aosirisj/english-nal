:- include('./traduccion/base').

%palabra_categoria(Dupla, Palabra, CG, Dict) es verdadero cuando 
palabra_categoria(Dupla, Palabra, CG, Dict):- re_matchsub('(.+?)/(.+)', Dupla, Dict, []),
                                              get_dict(1, Dict, P),
                                              atom_string(Palabra, P),
                                              get_dict(2, Dict, Cat),
                                              atom_string(CG, Cat).
                                              
dict_categorias(Linea, DictPalCG):- split_string(Linea, ' ', '', Duplas),
                                    findall(Palabra:CG, (member(Dupla, Duplas), palabra_categoria(Dupla, Palabra, CG, _)), 
                                            PalabrasCat),
                                    %list_to_set(ListaCat, PalabrasCat),
                                    %zip_unzip(Oracion, _, PalabrasCat),
                                    numerar(PalabrasCat, DictPalCG).
                                    %dict_create(DictPalCG, _, PalabrasCat).
                                                                 
tripleta(Tripleta, Cabeza, PosC, Rel, Dep, PosD):- re_matchsub('(.+)\\((.+?)-(\\d+?), (.+?)-(\\d+?)\\)', Tripleta, Dict, []),
                                                   get_dict(1, Dict, R),
                                                   atom_string(Rel, R),
                                                   get_dict(2, Dict, C),
                                                   atom_string(Cabeza, C),
                                                   get_dict(3, Dict, PC),
                                                   atom_string(PosC, PC),
                                                   get_dict(4, Dict, D),
                                                   atom_string(Dep, D),
                                                   get_dict(5, Dict, PD),
                                                   atom_string(PosD, PD).                                                
                                                   
encontrar_CGs_dependencias(InstanciaP, Dict, Dependencias):- atomic_list_concat(Contenido, "\n\n", InstanciaP),
                                                             partition(is_odd_element(Contenido), Contenido, [OracionCG|_], [DepsPlanas]),
                                                             dict_categorias(OracionCG, Dict),
                                                             atomic_list_concat(Dependencias, "\n", DepsPlanas).
                                                         
encontrar_CGs_dependencias_id(IdIns, OracionCG, Deps):- atomic_list_concat(["./traduccion/parsed/", IdIns, ".txt"], Direccion),
                                                        read_file_to_string(Direccion, Instancia, []),
                                                        encontrar_CGs_dependencias(Instancia, OracionCG, Deps).
                                                        
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
                                                     findall(Dependiente, (member(T, Tripletas), 
                                                                 tripleta(T, Cabeza, _, Dep, Dependiente, _)), Deps),
                                                      Deps = [].            
                                                     
descartar_dep(Tripletas, Dep, Cabeza, Dependiente):- member(T, Tripletas),
                                                     not(tripleta(T, Cabeza, _, Dep,Dependiente,_)).
                                                     
encontrar_dep_con_prep(Dict, Deps, Dep, Cabeza, Dependiente, Prep):- es_categoria(Dict, Preposicion, preposicion),
                     						    palabra_pos(Preposicion, Prep, _),
                                                                    atomic_list_concat([Dep, ':', Prep], DepPrep),
                                                                    member(T, Deps),
                                                                    tripleta(T, Cab, PosC, DepPrep, Depe, PosD),
                                                                    atomic_list_concat([Cab, '-', PosC], Cabeza),
                                                                    atomic_list_concat([Depe, '-', PosD], Dependiente). 

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
                                                 
                                                 
                                                                                                    
