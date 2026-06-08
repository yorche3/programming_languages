#ifndef WORDS_H
#define WORDS_H

#include <string>
#include <vector>

class Words {
public:
    std::string reverse_string(const std::string& str);
    bool is_palindrome(const std::string& str);
    bool kmp_search(const std::string& sub, const std::string& str);
    int lcs(const std::string& str1, const std::string& str2);
private:
    std::vector<int> compute_lps_array(const std::string& pattern);
};

#endif