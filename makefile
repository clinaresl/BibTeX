#
# Makefile para manipular los ficheros .bib
#
# Abril 1996 - Julio 2005 - Octubre 2006
# Carlos Linares Lopez
#
# carlos.linares@uc3m.es
#

#
# Configuracion
#
.SILENT:

# Macros

BIBSTYLE = plain
HTMLCSS  = plg.css

SRCBIB =
SRCTEX =
SRCOUT = tmp.bib
DIR    = 

#
# Entrada por defecto (useless)
#

.DEFAULT: 
	echo ""
	echo "No se pudo ejecutar la accion solicitada"
	echo "Make help si desea mas ayuda"
	echo ""

#
# Reglas de sufijos
#

.SUFFIXES: .bib .tex .dvi .ps .pdf .html

.bib.tex:
	echo "Creacion del fichero Inicial, ..."
	echo "\documentclass[a4paper]{article}" > $@
	echo "" >> $@
	echo "\\\\begin{document}" >> $@
	echo "" >> $@
	echo "\\\\nocite{*}" >> $@
	echo "" >> $@
	echo "\\\\bibliographystyle{" $(BIBSTYLE) "}" >> $@
	echo "\\\\bibliography{" $* "}" >> $@
	echo "" >> $@
	echo "\\\\end{document}" >> $@
	echo "" >> $@

	echo "Eliminacion de espacios en blanco, ..."
	tr -d " " < $@ > tmp.bib
	mv tmp.bib $@

	echo "Ok"
	echo ""

.tex.dvi:
	latex $<
	bibtex $*
	latex $<
	latex $<

	echo "Ok"
	echo ""

.dvi.ps:
	dvips $< -o $@

	echo "Ok"
	echo ""

.dvi.pdf:
	dvipdf $< $@

	echo "Ok"
	echo ""

.bib.html:
	bibtex2html --sort-by-date --style-sheet $(HTMLCSS) --style $(BIBSTYLE) --output $* $< 

#
# Label: etiqueta cada una de las referencias bibliograficas del fichero .bib
#        seleccionado.
#
label: $(SRCBIB)
	bibtool -K -i $(SRCBIB) -o $(SRCOUT)
	mv $(SRCOUT) $(SRCBIB)

#
# Sort: Ordenación ascendente de todas las entradas del fichero indicado
#       en SRCBIB
#
sort: $(SRCBIB)
	bibtool -s -i $(SRCBIB) -o $(SRCOUT)
	mv $(SRCOUT) $(SRCBIB)

#
# Install: Instalación de todos los ficheros .bib en el directorio indicado por
#          la macro DIR
#
install:
	cp *.bib $(DIR)
	echo " Instalación completada"
	echo ""

#
# Clean: Borrado de todos los ficheros intermedios
#
clean:
	rm *.aux
	rm *.bbl
	rm *.blg
	rm *.log

#
# Help:  Ofrece mensajes sobre todas las opciones disponibles, ...
#
help:
	@echo ""
	@echo "make label SRCBIB=<fichero bib> para etiquetar automaticamente"
	@echo "make sort  SRCBIB=<fichero bib> para ordenar todas las entradas"
	@echo "make install DIR =<directorio > para instalar todos los .bib"
	@echo "make clean para eliminar todos los ficheros intermedios"
	@echo ""
	@echo "make <fichero  tex> para crear un  .tex a partir de un .bib"
	@echo "make <fichero  dvi> para crear un  .dvi a partir de un .bib"
	@echo "make <fichero   ps> para crear un   .ps a partir de un .bib"
	@echo "make <fichero  pdf> para crear un  .pdf a partir de un .bib"
	@echo "make <fichero html> para crear un .html a partir de un .bib"
	@echo ""
	@echo "Macros:"
	@echo "   BIBSTYLE: Estilo de la bibliografia"
	@echo "             (valor por defecto: plain)"
	@echo "   HTMLCSS:  Fichero de estilos para la generación de .html"
	@echo "             (valor por defecto: plg.css)"
	@echo ""

