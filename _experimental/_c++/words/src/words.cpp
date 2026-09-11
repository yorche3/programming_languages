#include "../include/words.h"

#include <string>
#include <vector>
#include <sstream>
#include <algorithm>

std::string Words::reverse_string(const std::string& str) {
    int len_str = str.length();
    std::ostringstream buffer;
    for(int i = 0; i < len_str; i++) {
        buffer << str[len_str - 1 - i];
    }
    
    return buffer.str();
}

bool Words::is_palindrome(const std::string& str) {
    std::string local_str = str;
    local_str.erase(std::remove_if(local_str.begin(), local_str.end(), ::isspace), local_str.end());
    int i = 0;
    int j = local_str.length() - 1;
    while(i < j) {
        if(local_str[i++] != local_str[j--]) return false;
    }
    
    return true;
}

std::vector<int> Words::compute_lps_array(const std::string& pattern) {
    int len_pattern = pattern.length();
    std::vector<int> lps(len_pattern, 0);
    int length = 0;
    int i = 1;

    while(i < len_pattern) {
        if(pattern[i] == pattern[length]) {
            length++;
            lps[i] = length;
            i++;
        } else {
            if (length != 0) {
                length = lps[length - 1];
            } else {
                lps[i] = 0;
                i++;
            }
        }
    }

    return lps;
}

bool Words::kmp_search(const std::string& sub, const std::string& str) {
    int len_sub = sub.length();
    int len_str = str.length();
    if(len_sub == 0) return true;
    else if(len_sub > len_str) return false;

    std::vector<int> lps = compute_lps_array(sub);
    int i = 0;
    int j = 0;
    while(i < len_str) {
        if(str[i] == sub[j]) {
            i++;
            j++;
            if(j == len_sub) {
                return true;
            }
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

int Words::lcs(const std::string& str1, const std::string& str2) {
    int len_str1 = str1.length();
    int len_str2 = str2.length();
    std::vector<std::vector<int>> dp(len_str1 + 1, std::vector<int>(len_str2 + 1, 0));

    for(int i = 1; i <= len_str1; i++) {
        for(int j = 1; j <= len_str2; j++){
            if(str1[i - 1] == str2[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                dp[i][j] = std::max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }

    return dp[len_str1][len_str2];
}