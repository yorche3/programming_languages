# Makefile for COBOL programs

# Compiler command
COBOL = cobc

# Source files
SOURCES = Fibonacci.cbl Factorial.cbl SumNumbers.cbl RunTests.cbl

# Object files
OBJECTS = Fibonacci.o Factorial.o SumNumbers.o

# Executable name
EXECUTABLE = RunTests

# Default target
all: $(EXECUTABLE)

# Build the executable by compiling and linking
$(EXECUTABLE): $(OBJECTS)
	$(COBOL) -x RunTests.cbl $(OBJECTS) -o $(EXECUTABLE)

# Compile individual COBOL source files to object files
Fibonacci.o: Fibonacci.cbl
	$(COBOL) -c Fibonacci.cbl -o Fibonacci.o

Factorial.o: Factorial.cbl
	$(COBOL) -c Factorial.cbl -o Factorial.o

SumNumbers.o: SumNumbers.cbl
	$(COBOL) -c SumNumbers.cbl -o SumNumbers.o

# Clean up generated files
clean:
	rm -f $(OBJECTS) RunTests.o $(EXECUTABLE)

run: $(EXECUTABLE)
	./$(EXECUTABLE)

.PHONY: all clean