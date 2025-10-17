module words;

import std.string;
import std.regex;
import std.conv;
import std.algorithm;

class Words {
    static string reverse_string(string str) {
        int len = cast(int) str.length;
        char[] buffer_string = new char[len];
        for(int i = 0; i < len; i++) {
            buffer_string[i] = str[len - 1 - i];
        }
        return to!string(buffer_string);
    }

    static bool is_palindrome(string str) {
        string cleaned_str = str.replaceAll(regex(`\s+`), "");
        int i = 0;
        int j = cast(int) cleaned_str.length - 1;
        char aux;
        while(i < j) {
            if(cleaned_str[i] != cleaned_str[j]) return false;
            i++;
            j--;
        }
        return true;
    }

    private static int[] compute_lps_array(string patt) {
        int len_patt = cast(int) patt.length;
        int[] lps = new int[](len_patt);
        int i = 1;
        int len = 0;
        while(i < len_patt) {
            if(patt[i] == patt[len]) {
                len++;
                lps[i] = len;
                i++;
            } else {
                if(len != 0) {
                    len = lps[len - 1];
                } else {
                    lps[i++] = 0;
                }
            }
        }
        return lps;
    }

    static bool kmp_search(string sub, string str) {
        int len_sub = cast(int) sub.length;
        int len_str = cast(int) str.length;
        if(len_sub == 0) return true;
        else if(len_sub > len_str) return false;
        int[] lps = compute_lps_array(sub);
        int i = 0;
        int j = 0;
        while(i < len_str) {
            if(str[i] == sub[j]) {
                i++;
                j++;
                if(j == len_sub) return true;
            } else {
                if(j != 0) {
                    j = lps[j - 1];
                } else {
                    i++;
                }
            }
        }
        return false;
    }

    static int lcs(string str1, string str2) {
        int len_str1 = cast(int) str1.length;
        int len_str2 = cast(int) str2.length;
         int[][] dp = new int[][](len_str1 + 1);
        foreach (i; 0 .. len_str1 + 1)
            dp[i] = new int[](len_str2 + 1);
        foreach(i; 1..len_str1+1) {
            foreach(j; 1..len_str2+1) {
                if(str1[i - 1] == str2[j - 1]){
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[len_str1][len_str2];
    }
}