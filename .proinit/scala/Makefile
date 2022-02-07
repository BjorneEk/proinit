


SC = scalac

SCALA_SOURCES = $(wildcard src/*.scala)
#CLASSES  = $(files:src/%.scala=$(PACKAGE)/%.class)
#CLASSES = ${SCALA_SOURCES:.scala=.o}

# First rule is the one executed when no parameters are fed to the Makefile

all: $(SCALA_SOURCES)
	$(SC) $^

run: all # try replacing all with CLASSES?
	scala $(PACKAGE)/Main

clean:
	$(RM) $(PACKAGE)/*.class $(PACKAGE)/*.tasty
