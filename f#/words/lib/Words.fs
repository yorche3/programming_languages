namespace lib.Words

open System.Text
open System.Text.RegularExpressions

module Words =
  let reverseString (str: string) =
    let sb = StringBuilder()
    for i = str.Length - 1 downto 0 do
      sb.Append(str.[i]) |> ignore
    sb.ToString()

  let isPalindrome (str: string) =
    let cleanedStr = Regex.Replace(str.ToLower(), @"\s+", "")
    let rec verify (s: string) i j =
      if i >= j then
        true
      else if s.[i] <> s.[j] then
        false
      else
        verify s (i + 1) (j - 1)
    verify cleanedStr 0 (cleanedStr.Length - 1)

  let computeLPSArray (pat: string) =
    let lenPat = pat.Length
    let lps = Array.init lenPat (fun _ -> 0)
    let i = 1
    let len = 0
    while i < lenPat do
      if pat.[i] = pat.[len] then
        len <- len + 1
        lps.[i] <- len
        i <- i + 1
      else
        if len <> 0 then
          len <- lps.[len - 1]
        else
          lps.[i] <- 0
          i <- i + 1
    lps

  let kmpSearch (sub: string) (str: string) =
    
    false

  let lcs str1 str2 =
    0