VPATH = lib
vpath %.bib .:bibliography
vpath %.csl styles
vpath %.yaml .:spec
vpath default.% lib

SRC    = $(wildcard *.md)
LATEX := $(patsubst %.md,tex/%.md, $(SRC))
PAGES := $(patsubst %,tmp/%, $(SRC))

authorea : $(LATEX)

tex/%.md : %.md authorea.yaml biblio.bib
	docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` \
		palazzo/pandoc-xnos:edge -o $@ -d spec/authorea.yaml $<

build : $(PAGES)

tmp/%.md : %.md jekyll.yaml biblio.bib
	docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` \
		pandoc/core:2.9.2.1 -o $@ -d spec/jekyll.yaml $<
