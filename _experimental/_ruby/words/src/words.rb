module Words
  def self.reverse_string(str)
    reversed = ''
    for i in (str.length - 1).downto(0)
      reversed << str[i]
    end
    reversed
  end

  def self.is_palindrome(str)
    cleaned_str = str.gsub(/\s/, '')
    for i in 0...(cleaned_str.length / 2)
      return false if cleaned_str[i] != cleaned_str[cleaned_str.length - 1 - i]
    end
    true
  end

  def self.kmp_search(sub, str)
    len_sub = sub.length
    len_str = str.length
    if len_sub == 0
      true
    elsif len_sub > len_str
      false
    else
      lps = self.compute_lps_array(sub)
      i = 0
      j = 0
      while i < len_str
        if str[i] == sub[j]
          i += 1
          j += 1
          if j == len_sub
            return true
          end
        else
          if j > 0
            j = lps[j - 1]
          else
            i += 1
          end
        end
      end
      false
    end
  end

  def self.lcs(str1, str2)
    len1 = str1.length
    len2 = str2.length
    dp = Array.new(len1 + 1) { Array.new(len2 + 1, 0) }
    for i in 1..len1
      for j in 1..len2
        if str1[i - 1] == str2[j - 1]
          dp[i][j] = dp[i - 1][j - 1] + 1
        else
          dp[i][j] = [dp[i - 1][j], dp[i][j - 1]].max
        end
      end
    end
    dp[len1][len2]
  end

  private
  def self.compute_lps_array(pat)
    len_pat = pat.length
    lps = Array.new(len_pat, 0)
    i = 1
    len = 0
    while i < len_pat
      if pat[i] == pat[len]
        len += 1
        lps[i] = len
        i += 1
      else
        if len > 0
          len = lps[len - 1]
        else
          lps[i] = 0
          i += 1
        end
      end
    end
    lps
  end
end