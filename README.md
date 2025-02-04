# English to NAL

This repository contains the implementation in Prolog of the rule set described in the paper [Non-Axiomatic Logic Modeling of English Texts for Knowledge Discovery and Commonsense Reasoning](https://www.mdpi.com/2076-3417/13/20/11535) for writing English sentences in the language of Non-Axiomatic Logic (NAL).

## Prerequisites

- SWI-Prolog
- Python3

## Installation

- Fix a current working directory
- Download [Stanford Parser version 4.2.0](https://nlp.stanford.edu/software/lex-parser.shtml#Download) and copy _stanford-parser-full-2020-11-17_ folder in your working directory. If necessary, uncompress the models (_stanford-parser-4.2.0-models_) and copy the model _englishPCFG.ser.gz_ in the SP directory
- Download Stanford [Name Entity Recognizer version 4.2.0](https://nlp.stanford.edu/software/CRF-NER.shtml#Download) and copy _stanford-ner-4.2.0_ folder in your working directory
- Clone [Wordnet-prolog](https://github.com/ekaf/wordnet-prolog) or copy folder _wordnet-prolog-master_ in your working directory
- Clone this project or copy folder _traduccion_ in your working directory

## Usage

- Open a terminal in the working directory and excute SWI-Prolog

```bash
swipl
```
- In SWI-Prolog, Consult _traduccion.pl_ and use predicate _traduccion_

```prolog
consult(./traduccion/traduccion.pl)

% Predicade for translating. Replace variable Sentence with an English sentence. Variable J will keep the resulting judgments.
traduccion(Sentence, J).
```

For example,

```prolog
traduccion("Ana teaches me Logic", J).
```
will give the result:

```prolog
J = [juicio(inheritance(['{Ana-1}', 'Logic-4', '{I-3}'], 'teach-2'), [1, 0.9])] ;
```
that represents judgement (×, {Ana}, logic, {I}) ⟶ teach with truth value (1, 0.9). 
In general, _juicio_ is a binary predicate where the first argument represents an inheritance sentence and the second argument represents the truth value of the judgement. Besides, _inheritance_ is also a binary predicate that represents an inheritance relation; the first argument represents the subject of the sentence, and the second argument represents the predicate of the sentence.
In other words, a judgement S ⟶ P (f, c) will be represented by the predicades _juicio_ and _inheritance_ as juicio(inheritance(S, P), [f, c]).

## Notes

- If you want to change folder names, versions, or use other models, change paths in traduccion.pl
- Parsed dependencies can be seen in /traduccion/parsed/parsed.txt and sometimes can be a little off. You can change these dependencies if necessary. After rectifying the dependencies, use predicate _crear\_juicios(J)_ instead of _traduccion(S, J)_.
- The names of some predicates are written in Spanish (traduccion, crear_juicios, lemas, etc).

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.


