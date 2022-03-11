%Predicados comunes a toda la traducción

:-use_module(library(pcre)).

%is_odd_element(L, A) es verdadero cuando A tiene un índice impar en L.
%L - Lista
%A - Any
is_odd_element([A], A).

is_odd_element([A, _|B], X) :- A = X, !;
                               is_odd_element(B, X).
                               
imprimir(Lista) :- foreach(member(X, Lista), writeln(X)).                                                                  

%Listas de abreviaciones de PoS tags de Penn Treebank. Para nuestros fines sólo es necesario identificar la función de estos 4 tipos.
adjectivo(T):- member(T, ['JJ', 'JJR', 'JJS']).

sustantivo(T):- member(T, ['NN', 'NNS', 'NNP', 'NNPS']).

adverbio(T):- member(T, ['RB', 'RBR', 'RBS']).

verbo(T):- member(T, ['VB', 'VBD', 'VBG', 'VBN', 'VBP', 'VBZ']).

%palabra_categoria(Dupla, Palabra, CG, Dict) es verdadero cuando 
palabra_categoria(Dupla, Palabra, CG, Dict):- re_matchsub('(.+?)/(.+)', Dupla, Dict, []),
                                              get_dict(1, Dict, Palabra),
                                              get_dict(2, Dict, CG).
                                              
categorias(Linea, PalabrasCat):- split_string(Linea, " ", "", Duplas),
                                 findall(Palabra:CG, (member(Dupla, Duplas), palabra_categoria(Dupla, Palabra, CG, _)),PalabrasCat).
                                                                 
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
                                                   
encontrar_oraciones(InstanciaP, Oraciones, Dependencias):- atomic_list_concat(Contenido, "\n\n", InstanciaP),
                                                           partition(is_odd_element(Contenido), Contenido, Oraciones, Dependencias).
                                                         
encontrar_oraciones_id(IdIns, Oraciones, Deps):- atomic_list_concat(["/home/alejandra/Documents/tareasDCC/eso/",
                                                                     "traduccion/parsed/", IdIns, ".txt"], Direccion),
                                                 read_file_to_string(Direccion, Instancia, []),
                                                 encontrar_oraciones(Instancia, Oraciones, Deps).
                                                 
                                                 
                                                                                                    
