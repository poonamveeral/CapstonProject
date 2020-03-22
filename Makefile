#########################
# Tutorials on Makefile #
#########################

# http://www.gnu.org/software/make/manual/make.html
# http://nuclear.mutantstargoat.com/articles/make/

###########################
# Makefile global options #
###########################

MAKEFLAGS:= -j
# Maximize parallel execution whenever possible
OPTIONSPANDOC:= --toc --filter pandoc-numbering --filter pandoc-citeproc --filter pandoc-include-code --top-level-division=chapter -M date="$$(LANG=en_us_88591 date '+%B  %e, %Y (%r)')"
# Options common to all invokations of pandoc. Cf https://pandoc.org/MANUAL.html to understand them.
.DEFAULT_GOAL:= all
# By default, we construct all the files.
FIG_FOLDER = fig/*/
# Folder where source code for figures are present.
FIG_SOURCE = $(FIG_FOLDER)*.tex
# Source code for figures
FIG_PDF = $(FIG_FOLDER)*.pdf
# Figures in pdf format

#########
# Rules #
#########

# "Phony" rule to compile the figures into pdf using latexmk
# This must be run before compiling the pdf.

.PHONY: fig $(FIG_SOURCE)
fig : $(FIG_SOURCE)
$(FIG_SOURCE):
	latexmk -silent -cd -pdf $@
# latexmk automates and simplifies the latex compilation of the figures.
	
# "Phony" rule to convert the pdf figures to svg (for better integration in htm and odt output).
# This must be run before compiling the odt or html.

.PHONY: fig_svg $(FIG_PDF)
fig_svg: $(FIG_PDF)
$(FIG_PDF): $(FIG_SOURCE)
# $(FIG_SOURCE) is an "order-only" pre-requisite. Cf. http://www.gnu.org/software/make/manual/make.html#Types-of-Prerequisites
# This means that we force fig to be executed before executing fig_svg
	pdf2svg $@ $(addsuffix .svg,$(basename $@))
# To understand this syntax, cf. https://www.gnu.org/software/make/manual/html_node/File-Name-Functions.html#File-Name-Functions

# Rule to compile to html

html: example.md
	pandoc $(OPTIONSPANDOC) --css=style/style.css --toc-depth=1 --self-contained --default-image-extension=svg -o example.html $<


# Rule to compile to odt

odt: example.md
	pandoc  $(OPTIONSPANDOC) --default-image-extension=svg -o example.odt $<


# Rule to compile to pdf

pdf: example.md
	pandoc $(OPTIONSPANDOC) --pdf-engine=xelatex --pdf-engine-opt=-shell-escape -V links-as-notes --default-image-extension=pdf -o example.pdf $<


# Rule to compile to mediawiki

mediawiki: example.md
	pandoc $(OPTIONSPANDOC) --default-image-extension=svg --to mediawiki -o example.mw $<


# Rule to compile a temporary file, for testing purposes

temp: example.md
	pandoc $(OPTIONSPANDOC) --default-image-extension=svg --css=style/style.css --toc-depth=1 --self-contained -o temp.html $<
	pandoc $(OPTIONSPANDOC) --default-image-extension=svg -o temp.odt $<
	pandoc $(OPTIONSPANDOC) --pdf-engine=xelatex --pdf-engine-opt=-shell-escape -V links-as-notes --default-image-extension=pdf -o temp.pdf $<



# Rule to compile the readme file.

readme: ../README.md
	pandoc ../README.md -s -o ../README.html

# "Phony" rule to compile all three versions (html, odt, pdf) of the document

.PHONY: all
all: pdf odt html


# "Phony" rule to remove the temporary files.

.PHONY: clean
clean: 
	rm -f lectures_notes.pdf  lectures_notes.odt lectures_notes.html
	rm -f temp.html temp.pdf temp.odt
	rm -f ../README.html
	find fig/*/ -type f -not -name '*.tex' -and -not -name '*.def'  -and -not -name '*.sty' -delete
# Every file that does not have the extension .tex or the extension .def is removed from all the folders in fig.

# "Phony" rule to indent properly the latex files
#.PHONY: clean_latex $(FIG_SOURCE)
#clean_latex: $(FIG_SOURCE)
#$(FIG_SOURCE):
#	latexindent -w -s $@
# git clean -ni
