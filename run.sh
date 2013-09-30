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
