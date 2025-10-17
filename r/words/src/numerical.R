fibonacci <- function(n) {
	if (n < 0) {
		return(-1)
	} else if (n < 2) {
		return(n)
	}
	acc1 <- 1
	acc2 <- 0
	for (i in 3:n) {
		temp <- acc1
		acc1 <- acc1 + acc2
		acc2 <- temp
	}
	return(acc1 + acc2)
}

factorial <- function(n) {
	if (n < 0) {
		return(-1)
	} else if (n == 0) {
		return(1)
	}
	acc <- 1
	for (i in 2:n) {
		acc <- acc * i
	}
	return(acc)
}

gcd <- function(a, b) {
	while (b != 0) {
		temp <- b
		b <- a %% b
		a <- temp
	}
	return(a)
}

lcm <- function(a, b) {
	return((a / gcd(a, b)) * b)
}