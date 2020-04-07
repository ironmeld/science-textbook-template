MAINTEX=stb-template

default: $(MAINTEX).pdf $(MAINTEX)-letter.pdf

# The texlive* packages and latexmk must be installed
# booksvg.pdf was created from book.svg using an online conversion tool

$(MAINTEX).pdf: $(MAINTEX).tex $(MAINTEX).ist booksvg.pdf
	latexmk -pdf $(MAINTEX).tex

$(MAINTEX)-letter.pdf: # $(MAINTEX).tex $(MAINTEX).ist booksvg.pdf
	# Create a new tex file for letter.
	cp $(MAINTEX).tex $(MAINTEX)-letter.tex
	# Uncomment the letter geometry.
	sed -i 's/% \(\\usepackage\[margin=\)/\1/' $(MAINTEX)-letter.tex
	# Comment out the book size geometry.
	sed -i 's/^\(\\usepackage\[bindingoffset\)/% \1/' $(MAINTEX)-letter.tex
	sed -i 's/^\([ ]*top=\)/% \1/' $(MAINTEX)-letter.tex
	sed -i 's/^\([ ]*left=\)/% \1/' $(MAINTEX)-letter.tex
	sed -i 's/^\([ ]*bottom=\)/% \1/' $(MAINTEX)-letter.tex
	sed -i 's/^\([ ]*paperwidth=\)/% \1/' $(MAINTEX)-letter.tex
	# Create an index stye
	cp $(MAINTEX).ist $(MAINTEX)-letter.ist
	latexmk -pdf $(MAINTEX)-letter.tex


# commitclean will do most of the work
clean: commitclean
	rm -fv {$(MAINTEX),$(MAINTEX)-letter}.pdf

# remove all generated files except the pdfs. good for a github commmit with current pdf
commitclean::
	rm -fv {$(MAINTEX),$(MAINTEX)-letter}.{toc,idx,log,aux,dvi,ilg,out,ind,fls,fdb_latexmk}
	# these are generatd
	rm -fv $(MAINTEX)-letter.ist
	rm -fv $(MAINTEX)-letter.tex

.PHONY: clean commitclean
