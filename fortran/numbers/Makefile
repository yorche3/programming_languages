# Variables
FC = gfortran
PFUNIT_FLAGS = -I/usr/local/pfunit/PFUNIT-4.12/include -L/usr/local/pfunit/PFUNIT-4.12/lib -lpFUnit
SRC_REC = src/numbers_recursive.f90
SRC_ITE = src/numbers_iterative.f90
TESTS = test/numbers_recursive_test.f90 test/numbers_iterative_test.f90 test/run_tests.f90

.PHONY: all clean

all: test/run_tests

# Compile numbers_recursive.f90
test/numbers_recursive_test.o: $(SRC_REC) $(TESTS)
	$(FC) -c $< -o $@ $(PFUNIT_FLAGS)

# Compile numbers_iterative.f90
test/numbers_iterative_test.o: $(SRC_ITE) $(TESTS)
	$(FC) -c $< -o $@ $(PFUNIT_FLAGS)

# Compile run_tests
test/run_tests.o: $(TESTS)
	$(FC) -c $< -o $@ $(PFUNIT_FLAGS)

# Link all
test/run_tests: test/numbers_recursive_test.o test/numbers_iterative_test.o test/run_tests.o
	$(FC) $^ -o $@ $(PFUNIT_FLAGS)

clean:
	rm -f test/*.o test/run_tests