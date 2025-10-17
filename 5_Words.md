# Words

Manipulating strings is a common task, so we will practice through various algorithms.

## Objectives

- Establish a basis for a library project (preferably with only algorithms, avoiding a main function). The goal is to write efficient algorithms for strings and numbers, including validation and user alerts when parameters are invalid.
- Implement algorithms for
  - Numerical
    - Fibonacci
    - Factorial
    - Greatest Common Divisor (GDC)
    - LowLeastest Common Multiple (LCM)
  - Word
    - Reverse
    - is Substring
    - Longest Common Subsequence (LCS)
    - is Palindrome

## Goals

- Strive for efficiency (focusing on one or more of [number of operations | memory usage | call stack frames])
- Create a structured project with src and test directories
- Write unit tests for multiple classes/modules/namespaces

```text
words
├── src
│   ├── numerical.ext
│   └── word.ext
├── test
│   ├── test_numerical.ext
│   ├── test_word.ext
│   └── run_tests.ext
├── script.sh
├── script.bat
├── Makefile
└── CMakeLists.txt
```
*Note: Scripts and makefiles are for languages without built-in unit testing frameworks, requiring compilation or linking.

## Example code

```pseudocode
container algorithms_numerical
    .- fibonacci(n)
        if n is 0 or 1
            return n
        acc2, acc1 = 0, 1
        while n > 2
            acc2, acc1 = acc1, acc1 + acc2
            n - 1
        return acc1 + acc2

    .- factorial(n)
        if n is 0 or 1
            return 1
        result = 1
        while n > 1
            result *= i
            n - 1
        return result

    .- gcd(a, b)
        while b != 0
            a, b = b, a % b
        return a

    .- lcm(a, b)
        return (a // gcd(a, b)) * b
```

```pseudocode
container algorithms_words
    .- reverse_string(s)
        chars = list of characters from s
        left = 0
        right = length of chars - 1
        while left < right
            swap chars[left] and chars[right]
            left = left + 1
            right = right - 1
        return string from chars
    
    .- is_substring(sub, string)
        return kmp_search(sub, string)

    .- compute_lps_array(pattern)
        lps = array of zeros, length of pattern
        length = 0
        i = 1
        while i < length of pattern
            if pattern[i] == pattern[length]
                length = length + 1
                lps[i] = length
                i = i + 1
            else
                if length != 0
                    length = lps[length - 1]
                else
                    lps[i] = 0
                    i = i + 1
        return lps

    .- kmp_search(text, pattern)
        lps = compute_lps_array(pattern)
        i = 0  # index for text
        j = 0  # index for pattern
        while i < length of text
            if text[i] == pattern[j]
                i = i + 1
                j = j + 1
                if j == length of pattern
                    return true  # pattern found
            else
                if j != 0
                    j = lps[j - 1]
                else
                    i = i + 1
        return false  # pattern not found

    .- longest_common_subsequence(str1, str2)
        create matrix dp of size (len(str1)+1) x (len(str2)+1)
        initialize with zeros
        for i in 1 to len(str1)
            for j in 1 to len(str2)
                if str1[i-1] == str2[j-1]
                    dp[i][j] = dp[i-1][j-1] + 1
                else
                    dp[i][j] = max(dp[i-1][j], dp[i][j-1])
        return dp[len(str1)][len(str2)]

    .- is_palindrome(word)
        i, j = 0, len(word) - 1
        while i < j
            if word[i] != word[j]
                return false
            i = i + 1
            j = j - 1
        return true
```
*Note: These solutions prioritize clarity and correctness; some may not be the most optimized but demonstrate clear logic and structure.

## Test Basis

```pseudocode
.- assert(result, expected)
    return result equals expected

.- test_fibonacci
    success is: true
    success is: success and assert(Factorial(-3), -1)
    success is: success and assert(Factorial(10), 55)
    success is: success and assert(Factorial(15), 610)
    if success
        print "Fibonacci [OK]"
    else
        print "Fibonacci [FAILED]"

.- test_factorial
    success is: true
    success is: success and assert(Factorial(-3), -1)
    success is: success and assert(Factorial(5), 120)
    success is: success and assert(Factorial(10), 3628800)
    if success
        print "Factorial [OK]"
    else
        print "Factorial [FAILED]"

.- test_gcd
    success is: true
    success is: success and assert(GCD(48, 18), 6)
    success is: success and assert(GCD(100, 25), 25)
    success is: success and assert(GCD(17, 13), 1)
    if success
        print "GCD [OK]"
    else
        print "GCD [FAILED]"

.- test_lcm
    success is: true
    success is: success and assert(LCM(4, 6), 12)
    success is: success and assert(LCM(21, 6), 42)
    success is: success and assert(LCM(7, 3), 21)
    if success
        print "LCM [OK]"
    else
        print "LCM [FAILED]"

.-suite
    test_fibonacci
    test_factorial
    test_gcd
    test_lcm

.-main
    suite
```