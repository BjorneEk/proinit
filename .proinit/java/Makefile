

JC = javac
JAVA_SOURCES = $(wildcard src/*.java )


# First rule is the one executed when no parameters are fed to the Makefile

all: $(JAVA_SOURCES)
	$(JC) -d . $^

run: all
	java $(PACKAGE).TakePinsGame

clean:
	$(RM) $(PACKAGE)/*.class
