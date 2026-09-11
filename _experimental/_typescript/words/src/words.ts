export function reverse_string(str: string): string {
	let reversed = '';
	for(let i = str.length - 1; i >= 0; i--) {
		reversed += str[i];
	}
	return reversed;
}

export function is_palindrome(str: string): boolean {
	const cleaned_str = str.replace(/\s/g, '');
	let i = 0, j = cleaned_str.length - 1;
	while(i < j) {
		if(cleaned_str[i] !== cleaned_str[j]) {
			return false;
		}
		i++;
		j--;
	}
	return true;
}

function compute_lps_array(patt: string): number[] {
	const len_patt = patt.length;
	let lps = new Array(len_patt);
	lps[0] = 0;
	let i = 1, len = 0;
	while(i < len_patt) {
		if(patt[i] === patt[len]) {
			len++;
			lps[i] = len;
			i++;
		} else {
			if(len !== 0) {
				len = lps[len - 1];
			} else {
				lps[i] = 0;
				i++;
			}
		}
	}
	return lps;
}

export function kmp_search(sub: string, str: string): boolean {
	const len_sub = sub.length;
	const len_str = str.length;
	if(len_sub === 0)
		return true;
	if(len_sub > len_str)
		return false;
	const lps = compute_lps_array(sub);
	let i = 0, j = 0;
	while(i < len_str) {
		if(str[i] === sub[j]) {
			i++;
			j++;
			if(j === len_sub) {
				return true;
			}
		} else {
			if(j !== 0) {
				j = lps[j - 1];
			} else {
				i++;
			}
		}
	}
	return false;
}

export function lcs(str1: string, str2: string): number {
	let len1 = str1.length;
	let len2 = str2.length;
	let dp = Array.from({length: len1 + 1}, () => Array(len2 + 1).fill(0));
	for (let i = 1; i <= len1; i++) {
		for (let j = 1; j <= len2; j++) {
			if (str1[i - 1] === str2[j - 1]) {
				dp[i][j] = dp[i - 1][j - 1] + 1;
			} else {
				dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
			}
		}
	}
	return dp[len1][len2];
}