import ballerina/regex;

public function reverseString(string str) returns string {
     string[] charArray = [];

    foreach var charValue in str {
        charArray.push(charValue);
    }

    int i = 0;
    int j = str.length()-1;
    string aux;

    while i < j {
        aux = charArray[i];
        charArray[i] = charArray[j];
        charArray[j] = aux;
        i = i + 1;
        j = j - 1;
    }
    return string:'join("", ...charArray);
}

public function isPalindrome(string str) returns boolean {
    string strTrimmed = regex:replaceAll(str, "\\s", "");
    
    int i = 0;
    int j = strTrimmed.length() - 1;
    while i < j {
        if strTrimmed[i] != strTrimmed[j] {
            return false;
        }
        i = i + 1;
        j = j - 1;
    }
    return true;
}

function arrayOfZeros(int size) returns int[] {
    int[] array = [];
    foreach var i in 0..<size {
        array.push(0);
    }
    return array;
}

function computeLPSArray(string pattern) returns int[] {
    int size = pattern.length();
    int[] lps = arrayOfZeros(size);
    int len = 0;
    int i = 1;
    while i < size {
        if pattern[i] == pattern[len] {
            len = len + 1;
            lps[i] = len;
            i = i + 1;
        } else {
            if len != 0 {
                len = lps[len - 1];
            } else {
                lps[i] = 0;
                i = i + 1;
            }
        }
    }
    return lps;
}

public function kmpSearch(string sub, string str) returns boolean {
    if sub.length() == 0 {
        return true;
    } else if str.length() < sub.length() {
        return false;
    }
    int lenghtPattern = sub.length();
    int lenghtText = str.length();
    int[] lps = computeLPSArray(sub);
    int i = 0;
    int j = 0;
    while i < lenghtText {
        if str[i] == sub[j] {
            i = i + 1;
            j = j + 1;
            if j == lenghtPattern {
                return true;
            }
        } else {
            if j != 0 {
                j = lps[j - 1];
            } else {
                i = i + 1;
            }
        }
    }
    return false;
}

function createMatrixOfZeros(int n, int m) returns int[][] {
    int[][] matrix = [];
    foreach var i in 0..<n {
        int[] row = arrayOfZeros(m);
        matrix.push(row);
    }
    return matrix;
}

public function lcs(string str1, string str2) returns int {
    int lengthStr1 = str1.length();
    int lengthStr2 = str2.length();
    int[][] dp = createMatrixOfZeros(lengthStr1 + 1, lengthStr2 + 1);
    foreach var i in 1..<lengthStr1+1 {
        foreach var j in 1..<lengthStr2+1 {
            if str1[i - 1] == str2[j - 1] {
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                dp[i][j] = int:max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }
    return dp[lengthStr1][lengthStr2];
}