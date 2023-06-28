:- include('./intensiones').
                                                  
preprocesamiento:- working_directory(CWD, CWD), 
                   atomic_list_concat(['cd ', CWD, 'stanford-parser-full-2020-11-17/\n java -mx4g -cp \"*\" edu.stanford.nlp.parser.lexparser.LexicalizedParser -retainTMPSubcategories -outputFormat \"wordsAndTags,typedDependencies\" ./englishPCFG.ser.gz ', CWD, 'ejemplo.txt > ', CWD, 'traduccion/parsed/parsed.txt'], LoadWN),
                   atomic_list_concat(['python3 ', CWD, 'lemas.py'], LoadLemas),
                   atomic_list_concat(['cd ', CWD, 'stanford-ner-4.2.0/stanford-ner-2020-11-17/\n java -mx1g -cp \"*:lib/*\" edu.stanford.nlp.ie.NERClassifierCombiner -textFile ', CWD, 'ejemplo.txt -ner.model classifiers/english.all.3class.distsim.crf.ser.gz,classifiers/english.conll.4class.distsim.crf.ser.gz,classifiers/english.muc.7class.distsim.crf.ser.gz -outputFormat tabbedEntities 2 > ', CWD, 'traduccion/ner/parsed.txt'], LoadNER),
                   atomic_list_concat([CWD, 'traduccion/lemas/parsed.txt'], Deps),
                   shell(LoadWN),
                   shell(LoadLemas),
                   shell(LoadNER),
                   consult(Deps).
                   
crear_juicios(Juicios):- encontrar_CGs_dependencias_id(parsed, Dict, Deps), 
                         id_juiciosEntidades(parsed, Dict, Deps),
                         idinstancia_a_juicios(parsed, Juicios),
                         importar_intensiones(Dict, 1).
                         
traduccion(Juicios):- preprocesamiento,
                      crear_juicios(Juicios).                                            


