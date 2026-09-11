#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#include "../include/words.h"

char* reverse_string(const char* str)
{
    size_t len = strlen(str);
    char* result = (char*)malloc(len + 1);
    if (result == NULL)
    {
        return NULL;
    }

    for (size_t i = 0; i < len; i++)
    {
        result[i] = str[len - 1 - i];
    }    
    result[len] = '\0';
    return result;
}

static char* remove_spaces(const char* str)
{
    size_t len = strlen(str);
    char* result = (char*)malloc(len + 1);
    if (result == NULL)
    {
        return NULL;
    }

    const char whitespaces [] = " \t\n\r";
    size_t count = 0;
    for (size_t i = 0; i < len; i++)
    {
        int is_white = false;
        for (size_t j = 0; j < sizeof(whitespaces); j++)
        {
            if (str[i] == whitespaces[j])
            {
                is_white = true;
            }
            
        }
        if (!is_white)
        {
            result[count++] = str[i];
        }
    }
    result[count] = '\0';
    return result;
}

bool is_palindrome(const char* str)
{
    char* cleaned_str = remove_spaces(str);
    if (cleaned_str == NULL)
    {
        return false;
    }

    int i = 0;
    int j = strlen(cleaned_str) - 1;

    while (i < j)
    {
        if (cleaned_str[i] != cleaned_str[j])
        {
            free(cleaned_str);
            return false;
        }
        i++;
        j--;
    }
    free(cleaned_str);
    return true;
}

static size_t* create_array(size_t n) {
    size_t* arr = malloc(n * sizeof(size_t));
    if (arr == NULL) {
        return NULL;
    }
    for (size_t i = 0; i < n; i++) {
        arr[i] = 0;
    }
    return arr;
}

static size_t* compute_lps_array (const char* pattern)
{
    size_t len_pattern = strlen(pattern);
    size_t* lps = create_array(len_pattern);
    if (lps == NULL)
    {
        return NULL;
    }
    
    size_t len = 0;
    size_t i = 1;
    while (i < len_pattern)
    {
        if (pattern[i] == pattern[len])
        {
            len++;
            lps[i] = len;
            i++;
        } else
        {
            if (len != 0)
            {
                len = lps[len - 1];
            } else
            {
                lps[i] = 0;
                i++;
            }
        }
    }
    
    return lps;
}

bool kmp_search(const char* sub, const char* str)
{
    size_t len_sub = strlen(sub);
    size_t len_str = strlen(str);
    if (len_sub == 0)
    {
        return true;
    } else if (len_sub > len_str)
    {
        return false;
    }
    
    size_t* lps = compute_lps_array(sub);
    if (lps == NULL)
    {
        return false;
    }
    
    size_t i = 0;
    size_t j = 0;
    while (i < len_str)
    {
        if (str[i] == sub[j])
        {
            i++;
            j++;
            if (j == len_sub)
            {
                free(lps);
                return true;
            }
        } else
        {
            if (j != 0)
            {
                j = lps[j - 1];
            } else
            {
                i++;
            }   
        }
    }

    free(lps);
    return false;
}

static size_t** create_matrix(size_t n, size_t m)
{
    size_t** matrix = malloc(n * sizeof(size_t*));
    if (matrix == NULL) {
        return NULL;
    }
    for (size_t i = 0; i < n; i++) {
        matrix[i] = create_array(m);
        if (matrix[i] == NULL) {
            for (size_t j = 0; j < i; j++) {
                free(matrix[j]);
            }
            free(matrix);
            return NULL;
        }
    }
    return matrix;
}

int lcs(const char* str1, const char* str2)
{
    size_t len_str1 = strlen(str1);
    size_t len_str2 = strlen(str2);
    size_t** dp = create_matrix(len_str1 + 1, len_str2+ 1);
    if (dp == NULL)
    {
        return -1;
    }

    for (size_t i = 1; i <= len_str1; i++)
    {
        for (size_t j = 1; j <= len_str2; j++)
        {
            if (str1[i - 1] == str2[j - 1])
            {
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else
            {
                dp[i][j] = MAX(dp[i - 1][j], dp[i][j - 1]);
            }
        }
        
    }
    

    size_t result = dp[len_str1][len_str2];
    free(dp);
    return result;
}