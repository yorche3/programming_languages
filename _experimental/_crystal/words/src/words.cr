module Words
  def self.reverse_string(str : String) : String
    chars = str.chars
    i = 0
    j = chars.size - 1
    while i < j
      chars[i], chars[j] = chars[j], chars[i]
      i += 1
      j -= 1
    end
    return chars.join
  end

  def self.is_palindrome(str : String) : Bool
    cleaned_string = str.gsub(/\s+/, "")
    i = 0
    j = cleaned_string.size - 1
    while i < j
      return false if cleaned_string[i] != cleaned_string[j]
      i += 1
      j -= 1
    end
    return true
  end

  def self.compute_lps_array(patt : String) : Array(Int32)
    len_patt = patt.size
    lps = Array.new(len_patt, 0)
    len = 0
    i = 1
    while i < len_patt
      if patt[i] == patt[len]
        len += 1
        lps[i] = len
        i += 1
      else
        if len != 0
          len = lps[len - 1]
        else
          lps[i] = 0
          i += 1
        end
      end
    end
    return lps
  end

  def self.kmp_search(sub : String, str : String) : Bool
    len_sub = sub.size
    len_str = str.size
    if len_sub == 0
      return true
    elsif len_sub > len_str
      return false
    end
    lps = compute_lps_array(sub)
    i = 0
    j = 0
    while i < len_str
      if str[i] == sub[j]
        i += 1
        j += 1
        return true if j == len_sub
      else
        if j != 0
          j = lps[j - 1]
        else
          i += 1
        end
      end
    end
    return false
  end

  def self.lcs(str1 : String, str2 : String) : Int32
    len1 = str1.size
    len2 = str2.size
    dp = Array.new(len1 + 1){ Array.new(len2 + 1, 0) }
    (1..len1).each do |i|
      (1..len2).each do |j|
        if str1[i - 1] == str2[j - 1]
          dp[i][j] = dp[i - 1][j - 1] + 1
        else
          dp[i][j] = [dp[i - 1][j], dp[i][j - 1]].max
        end
      end
    end
    return dp[len1][len2]
  end
end