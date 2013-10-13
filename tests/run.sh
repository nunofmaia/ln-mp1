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
  GLOBAL="trad_global.fsm"
  
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
  
  fsmcompile -i letras.syms -o letras.syms -t trad_isco.txt > "$ISCO"
  fsmcompile -i letras.syms -o letras.syms -t trad_orra.txt > "$ORRA"

  fsmunion "$ISCO" "$ORRA" > "$GLOBAL"
  fsmdraw -i letras.syms -o letras.syms "$GLOBAL" | dot -Tpdf > "${GLOBAL%.*}.pdf"
  
  # Compose word transducers with suffix tranducers
  
  for fsm in *.fsm
  do
      name="${fsm%.*}"
      fsmExtension="_out.fsm"
      pdfExtension="_out.pdf"
      if [ $fsm != $ISCO ] && [ $fsm != $ORRA ] && [ $fsm != $GLOBAL ]; then
        fsmcompose $fsm $GLOBAL > "$name$fsmExtension"
        fsmdraw -i letras.syms -o letras.syms "$name$fsmExtension" | dot -Tpdf > "$name$pdfExtension"
      fi
  done
fi
