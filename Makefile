SHELL = /usr/bin/bash
PKG = compositionality

VERSION = UNRELEASED
DATE = $(shell date +"%Y/%m/%d")

INTERPOLATIONS  = s@<DATE>@$(DATE)@g;
INTERPOLATIONS += s/<VERSION>/$(VERSION)/g;

$(PKG).tar.gz: $(PKG).ins $(PKG).pdf README.md
	ctanify --notds $^

$(PKG).pdf: $(PKG).dtx
	pdflatex $(PKG).dtx
	pdflatex $(PKG).dtx
	makeindex -s gglo.ist -o $(PKG).gls $(PKG).glo
	makeindex -s gind.ist -o $(PKG).ind $(PKG).idx
	pdflatex $(PKG).dtx
	pdflatex $(PKG).dtx

$(PKG).cls: $(PKG).ins $(PKG).dtx
	tex $<

watch:
	ls $(PKG).dtx | entr -c texfot pdflatex $(PKG).pdf

clean:
	rm -f $(PKG).{aux,glo,gls,hd,idx,ilg,ind,log,out}

clobber: clean
	rm -f $(PKG).{pdf,cls,tar.gz}

interpolate:
	sed -i "$(INTERPOLATIONS)" $(PKG).dtx