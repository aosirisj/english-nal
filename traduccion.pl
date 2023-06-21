:- include('/home/alejandra/Documents/tareasDCC/eso/traduccion/intensiones').
                                                  
preprocesamiento:- shell("cd stanford-parser-full-2020-11-17/\n java -mx4g -cp \"*\" edu.stanford.nlp.parser.lexparser.LexicalizedParser -retainTMPSubcategories -outputFormat \"wordsAndTags,typedDependencies\" /home/alejandra/englishPCFG.ser.gz /home/alejandra/ejemplo.txt > /home/alejandra/Documents/tareasDCC/eso/traduccion/parsed/parsed.txt"),
                   shell("python3 lemas.py"),
                   shell("cd stanford-ner-4.2.0/stanford-ner-2020-11-17/\n java -mx1g -cp \"*:lib/*\" edu.stanford.nlp.ie.NERClassifierCombiner -textFile /home/alejandra/ejemplo.txt -ner.model classifiers/english.all.3class.distsim.crf.ser.gz,classifiers/english.conll.4class.distsim.crf.ser.gz,classifiers/english.muc.7class.distsim.crf.ser.gz -outputFormat tabbedEntities 2 > /home/alejandra/Documents/tareasDCC/eso/traduccion/ner/parsed.txt"),
                   consult("/home/alejandra/Documents/tareasDCC/eso/traduccion/lemas/parsed.txt").
                   
crear_juicios(Juicios):- encontrar_CGs_dependencias_id(parsed, Dict, Deps), 
                         id_juiciosEntidades(parsed, Dict, Deps),
                         idinstancia_a_juicios(parsed, Juicios),
                         importar_intensiones(Dict, 1).
                         
traduccion(Juicios):- preprocesamiento,
                      crear_juicios(Juicios).                                            


