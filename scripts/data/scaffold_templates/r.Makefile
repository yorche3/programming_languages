R ?= Rscript

.PHONY: test clean

test:
	$(R) -e "results <- testthat::test_local(); if (sum(as.data.frame(results)[['passed']]) == 0L) stop('No R test cases executed')"

clean:
	rm -rf *.Rcheck
