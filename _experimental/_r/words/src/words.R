reverse_string <- function(s) {
  reversed <- ""
  len <- nchar(s)
  chars <- strsplit(s, NULL)[[1]]
  while (len > 0) {
    reversed <- paste0(reversed, chars[len])
    len <- len - 1
  }
  return(reversed)
}

is_palindrome <- function(s) {
  chars <- strsplit(gsub("\\s", "", s), NULL)[[1]]
  i <- 1
	j <- length(chars)
	while (i < j) {
		if (chars[i] != chars[j]) {
			return(FALSE)
		}
		i <- i + 1
		j <- j - 1
	}
	return(TRUE)
}

compute_lps_array <- function(pat){
	len_pat <- nchar(pat)
	lps <- rep(0, len_pat)
	len <- 0
	i <- 2
	while (i <= len_pat) {
		if (substr(pat, i, i) == substr(pat, len + 1, len + 1)) {
			len <- len + 1
			lps[i] <- len
			i <- i + 1
		} else {
			if (len != 0) {
				len <- lps[len]
			} else {
				lps[i] <- 0
				i <- i + 1
			}
		}
	}
	return(lps)
}

kmp_search <- function(pat, txt) {
	len_pat <- nchar(pat)
	len_txt <- nchar(txt)
	if (len_pat == 0) {
		return(TRUE)
	} else if (len_pat > len_txt) {
		return(FALSE)
	}
	lps <- compute_lps_array(pat)
	i <- 1
	j <- 1
	while (i <= len_txt) {
		if (substr(pat, j, j) == substr(txt, i, i)) {
			i <- i + 1
			j <- j + 1
			if (j > len_pat) {
				return(TRUE)
			}
		} else {
			if (j != 1) {
				j <- lps[j - 1] + 1
			} else {
				i <- i + 1
			}
		}
	}
	return(FALSE)
}

lcs <- function(str1, str2) {
	len1 <- nchar(str1)
	len2 <- nchar(str2)
	if (len1 == 0 || len2 == 0) {
		return(0)
	}
	dp <- matrix(0, nrow = len1 + 1, ncol = len2 + 1)
	for (i in 1:len1) {
		for (j in 1:len2) {
			if (substr(str1, i, i) == substr(str2, j, j)) {
				dp[i + 1, j + 1] <- dp[i, j] + 1
			} else {
				dp[i + 1, j + 1] <- max(dp[i + 1, j], dp[i, j + 1])
			}
		}
	}
	return(dp[len1 + 1, len2 + 1])
}