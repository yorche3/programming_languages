R ?= Rscript

.PHONY: test clean

test:
	$(R) -e "testthat::test_local()"

clean:
	rm -rf *.Rcheck
