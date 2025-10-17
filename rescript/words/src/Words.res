let reverse_string = str => {
  let reversed = ref("")
  for i in 0 to str->Js.String.length - 1 {
    reversed.contents = str->Js.String2.charAt(i) ++ reversed.contents
  }
  reversed.contents
}

let is_palindrome = str => {
	let len = str->Js.String.length
	let rec check = (i, j) =>
		if i >= j {
			true
		} else if str->Js.String2.charAt(i) != str->Js.String2.charAt(j) {
			false
		} else {
			check(i + 1, j - 1)
		}
	check(0, len - 1)
}

let kmp_search = (sub, str) => {
	let lenSub = sub->Js.String.length
	let lenStr = str->Js.String.length
	if lenSub == 0 {
		true
	} else if lenSub > lenStr {
		false
	} else {
		let lps = Array.make(lenSub, 0)
		let computeLPS = () => {
			let length = ref(0)
			let i = ref(1)
			while i.contents < lenSub {
				if sub->Js.String2.charAt(i.contents) == sub->Js.String2.charAt(length.contents) {
					length.contents = length.contents + 1;
					lps[i.contents] = length.contents
					i.contents = i.contents + 1;
				} else if length.contents != 0 {
					length.contents = lps[length.contents - 1]
				} else {
					lps[i.contents] = 0
					i.contents = i.contents + 1;
				}
			}
		}
		computeLPS()
		let i = ref(0)
		let j = ref(0)
		let res = ref(false)
		while i.contents < lenStr && !res.contents {
			if sub->Js.String2.charAt(j.contents) == str->Js.String2.charAt(i.contents) {
				i.contents = i.contents + 1;
				j.contents = j.contents + 1;
				if j.contents == lenSub {
					res.contents = true;
				}
			} else if j.contents != 0 {
				j.contents = lps[j.contents - 1]
			} else {
				i.contents = i.contents + 1;
			}
		}
		res.contents
	}
}

let lcs = (str1, str2) => {
	let len1 = str1->Js.String.length
	let len2 = str2->Js.String.length
	let dp = Array.make_matrix(len1 + 1, len2 + 1, 0)
	for i in 1 to len1 {
		for j in 1 to len2 {
			if str1->Js.String2.charAt(i - 1) == str2->Js.String2.charAt(j - 1) {
				dp[i][j] = dp[i - 1][j - 1] + 1
			} else {
				dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
			}
		}
	}
	dp[len1][len2]
}