#!/bin/bash

CLEAR="clean"
ALL="all"


if [ "$1" == "$CLEAR" ]
then
  rm -f *.pdf *.fsm
elif [ "$1" == "$ALL" ] || [ -z "$1" ]
then
  ISCO="trad_isco.fsm"
  ORRA="trad_orra.fsm"
  ZORRA="trad_zorra.fsm"
  
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
  
  fsmcompile -i letras.syms -o letras.syms -t trad_isco.txt > trad_isco.fsm
  fsmcompile -i letras.syms -o letras.syms -t trad_orra.txt > trad_orra.fsm
  fsmcompile -i letras.syms -o letras.syms -t trad_zorra.txt > trad_zorra.fsm
  
  # Compose word transducers with suffix tranducers
  
  for fsm in *.fsm
  do
      name="${fsm%.*}"
      fsmExtension="_out.fsm"
      pdfExtension="_out.pdf"
      if [ $fsm != $ISCO ] && [ $fsm != $ORRA ]; then
          if [[ $name == *orra ]]
          then
              fsmcompose $fsm $ORRA > "$name$fsmExtension"
              fsmdraw -i letras.syms -o letras.syms "$name$fsmExtension" | dot -Tpdf > "$name$pdfExtension"  
          elif [[ $name == *isco ]]
          then
              fsmcompose $fsm $ISCO > "$name$fsmExtension"
              fsmdraw -i letras.syms -o letras.syms "$name$fsmExtension" | dot -Tpdf > "$name$pdfExtension" 
          fi
      fi
  done
fi
