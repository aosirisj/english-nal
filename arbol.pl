%Los predicados de este módulo obtienen el código en dot para la representación gráfica de dependencias universales de una oración.
%Se espera que las dependencias universales esten escritas en una sola cadena con saltos de línea entre cada dependncia.

:- include('/home/alejandra/Documents/tareasDCC/eso/traduccion/base').

%arista(N1, N2, Rel, Arista) es verdadero cuando Arista es la linea en codigo dot para la arista dirigida que tiene como cabeza a N1 y como dependiente a N2. La flecha de la arista está etiquetada con Rel.
%Nondet
%N1, N2, Rel, Arista - átomos
arista(N1, N2, Rel, Arista):- atomic_list_concat(['\"', N1, '\"', ' -> ', '\"', N2, '\"', ' [label="', Rel, '",len=1.00];'], Arista).

%tripleta_a_arista(Tripleta, Arista) transforma una cadena de una relación de dependencias universales Tripleta en el código dot del la arista de esta dependencia utilizando el predicado arista/4. 
%Nondet
%Tripleta - cadena con una dependencia universales
%Arista - átomo
tripleta_a_arista(Tripleta, Arista):- tripleta(Tripleta, Cabeza, PosC, Rel, Dep, PosD),
                                      Rel \= "root",
                                      atomic_list_concat([Cabeza, "-", PosC], N1),
                                      atomic_list_concat([Dep, "-", PosD], N2),
                                      arista(N1, N2, Rel, Arista).

%arbol(Dependencias, Arbol) transforma la cadena de dependencias universales Dependencias en el código dot del árbol gráfico de estas dependencias. 
%Nondet
%Dependencias - cadena de dependencias universales separadas por saltos de línea
%Arbol - átomo
arbol(Dependencias, Arbol):- split_string(Dependencias, "\n", "", Tripletas),
                             findall(Arista, (member(Tripleta, Tripletas), tripleta_a_arista(Tripleta, Arista)), A),
                             append(["digraph{"], A, A1),
                             append(A1, ["} "], A2),
                             atomic_list_concat(A2, Arbol).                       

%idinstancia_a_arboles(IdIns) escribe un archivo dot del árbol gráfico de cada oración parseada en el documento con id IdIns (un archivo por cada oración, numerados desde 1).
idinstancia_a_arboles(IdIns):- encontrar_oraciones_id(IdIns, _, Deps), 
                               findall(_, (nth1(N, Deps, D), arbol(D, Dot), atomic_list_concat(["/home/alejandra/Documents/",
                                                     "tareasDCC/eso/traduccion/arboles/", IdIns, "/", N, ".dot"], Direccion),
                                           open(Direccion, write, Out), write(Out, Dot), close(Out)), _).
                                     
                                     
                                     
