import re
import sys
import time
import subprocess
import nltk as nltk
from nltk import sent_tokenize, word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.corpus import wordnet

lemmatizer = WordNetLemmatizer()

text = open('./traduccion/parsed/parsed.txt', 'r')
text = text.readlines()
text = text[0].split()
wcg = [word.split('/') for word in text]

lemas = []
for par in wcg:
    cg = par[1] 
    palabra = par[0]
    print(palabra)
    if cg in ['JJ']:
        lema = lemmatizer.lemmatize(palabra, 'a')
        lemas.append([palabra, lema])
    elif cg in ['NN', 'NNS']:
        lema = lemmatizer.lemmatize(palabra, 'n')
        lemas.append([palabra, lema])
    elif cg in ['VB', 'VBD', 'VBG', 'VBN', 'VBP', 'VBZ']:
        lema = lemmatizer.lemmatize(palabra, 'v')
        lemas.append([palabra, lema])
    elif cg in ['RB']:
        lema = lemmatizer.lemmatize(palabra, 'r')
        lemas.append([palabra, lema])
    elif cg not in ['.']:
        lemas.append([palabra, palabra])
        
predicado = ""
for par in lemas:
    pred = "lema('" + par[0] + "', '" + par[1] + "').\n"
    predicado = predicado + pred
    
f = open('./traduccion/lemas/parsed.txt', 'w')
f.write(predicado)
f.close()
    
        
