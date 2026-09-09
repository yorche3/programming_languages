pub fn reverse_string(s: &str) -> String {
	let mut reversed = String::new();
	for c in s.chars() {
		reversed.insert(0, c);
	}
	return reversed.to_string();
}

pub fn is_palindrome(s: &str) -> bool {
	let cleaned_s: String = s.chars().filter(|c| c.is_alphanumeric()).collect::<String>();
	let cleaned_s_chars = cleaned_s.chars().collect::<Vec<char>>();
	let length = cleaned_s_chars.len();
	for i in 0..(length / 2) {
		if cleaned_s_chars[i] != cleaned_s_chars[length - 1 - i] {
			return false;
		}
	}
	return true
}

fn compute_lps_array(pat: &str) -> Vec<usize> {
	let len_pat = pat.len();
	let mut lps = vec![0; len_pat];
	let mut i = 1;
	let mut length = 0;
	while i < len_pat {
		if pat.chars().nth(i) == pat.chars().nth(length) {
			length += 1;
			lps[i] = length;
			i += 1;
		} else {
			if length != 0 {
				length = lps[length - 1];
			} else {
				lps[i] = 0;
				i += 1;
			}
		}
	}
	return lps;
}

pub fn kmp_search(sub: &str, s: &str) -> bool {
	let len_sub = sub.len();
	let len_s = s.len();
	if len_sub == 0 {
		return true;
	}
	if len_sub > len_s {
		return false;
	}
	let lps = compute_lps_array(sub);
	let mut i = 0;
	let mut j = 0;
	while i < len_s {
		if sub.chars().nth(j) == s.chars().nth(i) {
			i += 1;
			j += 1;
			if j == len_sub {
				return true;
			}
		} else {
			if j != 0 {
				j = lps[j - 1];
			} else {
				i += 1;
			}
		}
	}
	return false;
}

pub fn lcs(_str1: &str, _str2: &str) -> i32 {
	let len1 = _str1.len();
	let len2 = _str2.len();
	let mut dp = vec![vec![0; len2 + 1]; len1 + 1];
	for i in 1..=len1 {
		for j in 1..=len2 {
			if _str1.chars().nth(i - 1) == _str2.chars().nth(j - 1) {
				dp[i][j] = dp[i - 1][j - 1] + 1;
			} else {
				dp[i][j] = std::cmp::max(dp[i - 1][j], dp[i][j - 1]);
			}
		}
	}
	return dp[len1][len2] as i32;
}