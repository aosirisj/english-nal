Fix a current working directory and copy there SP, NER and WN and folder traduccion
Open a terminal in the same directory and excute swipl
In swipl use predicate consult('./traduccion/traduccion.pl').
In file ejemplo.txt write an English sentence
Return to swipl terminal and use predicate traduccion(J).
Variable J will keep the resulting judgments
