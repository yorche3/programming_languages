namespace Words;

using System.Text;
using System.Text.RegularExpressions;

public class Class1
{
    public string ReverseString (string str)
    {
        StringBuilder sb = new StringBuilder();
        int len = str.Length;
        for (int i = 0; i < len; i++)
        {
            sb.Append(str[len - 1 - i]);
        }
        return sb.ToString();
    }

    public bool IsPalindrome (string str)
    {
        string cleanedStr = Regex.Replace(str, @"\s+", "");
        int i = 0;
        int j = cleanedStr.Length - 1;
        while (i < j)
        {
            if (cleanedStr[i++] != cleanedStr[j--])
            {
                return false;
            }
        }
        return true;
    }

    private int[] ComputeLPSArray (string pattern)
    {
        int[] lps = new int[pattern.Length];
        int lenPattern = pattern.Length;
        int len = 0;
        int i = 1;
        while (i < lenPattern)
        {
            if (pattern[i] == pattern[len])
            {
                len++;
                lps[i] = len;
                i++;
            }
            else
            {
                if (len != 0)
                {
                    len = lps[len - 1];
                }
                else
                {
                    lps[i] = 0;
                    i++;
                }
            }
        }
        return lps;
    }

    public bool IsSubstring (string sub, string str)
    {
        int lenSub = sub.Length;
        if (lenSub == 0)
        {
            return true;
        }
        int lenStr = str.Length;
        if (lenSub > lenStr)
        {
            return false;
        }

        int[] lps = ComputeLPSArray(sub);
        int i = 0;
        int j = 0;
        while (i < lenStr)
        {
            if (str[i] == sub[j])
            {
                i++;
                j++;
                if (j == lenSub)
                {
                    return true;
                }
            } else
            {
                if (j != 0)
                {
                    j = lps[j - 1];
                }
                else
                {
                    i++;
                }
            }
        }
        return false;
    }

    public int LCS (string str1, string str2)
    {
        int lenStr1 = str1.Length;
        int lenStr2 = str2.Length;
        if (lenStr1 == 0 || lenStr1 == 0)
        {
            return 0;
        }

        int[,] dp = new int[lenStr1 + 1, lenStr2 + 1];
        for (int i = 1; i <= lenStr1; i++)
        {
            for (int j = 1; j <= lenStr2; j++)
            {
                if (str1[i - 1] == str2[j - 1])
                {
                    dp[i,j] = dp[i - 1, j - 1] + 1;
                }
                else
                {
                    dp[i,j] = Math.Max(dp[i - 1, j], dp[i, j - 1]);
                }
            }
        }
        return dp[lenStr1, lenStr2];
    }
}
