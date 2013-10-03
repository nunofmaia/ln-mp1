#!/bin/bash

# Remove generated files
rm -f *.pdf *.fsm

# Compile transducers and generate its graphical representation
for file in *.txt
do
  fsmFile="${file%.*}.fsm"
  pdfFile="${file%.*}.pdf"
  fsmcompile -i letras.syms -o letras.syms -t $file > $fsmFile
  fsmdraw -i letras.syms -o letras.syms $fsmFile | dot -Tpdf > $pdfFile
done

# Compose word transducers with suffix tranducers
fsmcompose namorisco.fsm trad_isco.fsm > namoro.fsm
fsmdraw -i letras.syms -o letras.syms namoro.fsm | dot -Tpdf > namoro.pdf

fsmcompose mourisco.fsm trad_isco.fsm > mouro.fsm
fsmdraw -i letras.syms -o letras.syms mouro.fsm | dot -Tpdf > mouro.pdf

fsmcompose chuvisco.fsm trad_isco.fsm > chuva.fsm
fsmdraw -i letras.syms -o letras.syms chuva.fsm | dot -Tpdf > chuva.pdf
