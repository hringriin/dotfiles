FILENAME=EXAMPLE-FILE
# Hier den Namen der Tex Datei eintragen,
# aber OHNE DIE ENDUNG .tex !!!!


# Options
movepdf = yes	# decide whether to move or copy the pdf
				# binary to a 'build' directory


# Compile all ?
# available components:
#	- clean			# deletes all excess files, logs for instance
#	- rmpdf			# deletes the pdf binary (NOT IN THE 'BUILD' directory)
#	- document		# compiles the document, depending on
#					# made citations or glossary entries,
#					# they will be compiled, too.
#	- cppdf			# copies or moves (depending on settings)
#					# the pdf binary into a 'build' directory
all: document clean

# deletes alle excess files, logs for instance
clean:
	@echo "+--------------------------------------+";
	@echo "|  Loesche ueberfluessige Dateien ...  |";
	@echo "+--------------------------------------+";
	rm -f *.aux;
	rm -f *.bbl;
	rm -f *.blg;
	rm -f *.glg;
	rm -f *.glo;
	rm -f *.gls;
	rm -f *.ist;
	rm -f *.log;
	rm -f *.tdo;
	rm -f *.toc;
	rm -f *.out;

# deletes the pdf binary (NOT IN THE 'build' DIRECTORY!)
rmpdf:
	@echo "+-------------------+";
	@echo "|  Loesche die PDF  |";
	@echo "+-------------------+";
	rm -f $(FILENAME).pdf;

# Compiles the document, depending on made citations or glossary entiries,
# a bibliography and / or a glossary will be compiled, too.
document:
	@echo "+------------------------------------------------------+";
	@echo "|  Kompiliere das Dokument. Das kann jetzt dauern ...  |";
	@echo "+------------------------------------------------------+";
	pdflatex $(FILENAME).tex;
	@if(grep "citation" $(FILENAME).aux > /dev/null); \
		then \
			bibtex $(FILENAME); \
			pdflatex $(FILENAME).tex; \
	fi;

	@if(grep "istfilename" $(FILENAME).aux > /dev/null); \
		then \
			makeglossaries $(FILENAME); \
			pdflatex $(FILENAME).tex; \
			makeglossaries $(FILENAME); \
	fi;

	@if(grep "citation" $(FILENAME).aux > /dev/null); \
		then \
			bibtex $(FILENAME); \
			pdflatex $(FILENAME).tex; \
	fi;
	pdflatex $(FILENAME).tex;
	pdflatex $(FILENAME).tex;

# copies or moves (depending on settings) the pdf binary into
# a 'build' directory.
#cppdf:
#	@echo "\n\n\n\n+------------------------------------------------+";
#	@echo "|  Nur, wenn Du die PDF auch committen willst!;  |";
#	@echo "|  Antworte mit [y]es oder [n]o!                 |";
#	@echo "+------------------------------------------------+\n\n";
#	@if !(test -d ./build); \
#		then mkdir ./build \
#		&& echo "\nBuild directory created."; \
#		else echo "\nBuild directory exists. Nothing changed."; \
#	fi;
#	@cp -vi $(FILENAME).pdf ./build/
