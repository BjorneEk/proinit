
CC = g++
INCLUDE_DIR = src
CFLAGS = -I$(INCLUDE_DIR)
C_SOURCES = $(wildcard src/*.cpp *.cpp )
DEPS = $(wildcard $(INCLUDE_DIR)/*.h *.h)
OBJ = ${C_SOURCES:.cpp=.o}

# First rule is the one executed when no parameters are fed to the Makefile


%.o: %.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

$(TARGET): $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

clean:
	$(RM) src/*.bin src/*.o src/*.dis src/*.elf
	$(RM) lib/*.o
