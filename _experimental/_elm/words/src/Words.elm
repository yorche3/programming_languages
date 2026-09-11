module Words exposing (reverseString, isPalindrome, kmpSearch, lcs)

import Array exposing (Array, repeat)
import String exposing (length, slice)
import Matrix exposing (Matrix, repeat, get, set)

reverseString : String -> String
reverseString str =
  let
    loop remaining buffer = 
      case String.uncons remaining of
        Nothing -> buffer
        Just (ch, rest) -> loop rest ((String.fromChar ch) ++ buffer)
  in
    loop str ""

isPalindrome : String -> Bool
isPalindrome str =
  let
    normalized =
      str
        |> String.toLower
        |> String.filter (\c -> c /= ' ') -- ignore spaces
    reversed =
      reverseString normalized
  in
    normalized == reversed

computeLPSArray : String -> Array Int
computeLPSArray patt =
  let
    lenPatt = String.length patt
    lpsArray = Array.repeat lenPatt 0

    loop : Array Int -> Int -> Int -> Array Int
    loop lps i len =
        if i >= lenPatt then lps
        else
          if (String.slice (i - len) (i + 1) patt) == (String.slice 0 (len + 1) patt) then
            let
              lpsUpdated = Array.set i (len + 1) lps
            in
              loop lpsUpdated (i + 1) (len + 1)
          else
            if len /= 0 then
              loop lps i (Array.get (len - 1) lps |> Maybe.withDefault 0)
            else
              let
                lpsUpdated = Array.set i 0 lps
              in
                loop lpsUpdated (i + 1) 0
  in
    loop lpsArray 1 0

kmpSearch : String -> String -> Bool
kmpSearch sub str =
  let
    lenSub = String.length sub
    lenStr = String.length str

    result = 
      if lenSub == 0 then True
      else if lenSub > lenStr then False
      else
        let
          lps = computeLPSArray sub

          loop : Int -> Int -> Bool
          loop i j =
            if i >= lenStr then False
            else
              if (String.slice i (i + 1) str) == (String.slice j (j + 1) sub) then
                if (j + 1) == lenSub then True
                else loop (i + 1) (j + 1)
              else
                if j /= 0 then
                  case Array.get (j - 1) lps of
                    Just prevJ -> loop i prevJ
                    Nothing -> loop i 0
                else
                  loop (i + 1) j
        in
          loop 0 0

  in
    result

lcs : String -> String -> Int
lcs str1 str2 =
  let
    len1 = String.length str1
    len2 = String.length str2

    -- Initialize DP matrix with zeros
    dp : Matrix Int
    dp = Matrix.repeat (len1 + 1) (len2 + 1) 0

    -- Helper to get value with default
    getOrDefault : Int -> Int -> Matrix Int -> Int
    getOrDefault row col matrix =
        Result.withDefault 0 (Matrix.get row col matrix)

    -- Fill DP table
    filledDP : Matrix Int
    filledDP =
      let
        -- process row i
        loopI : Int -> Matrix Int -> Matrix Int
        loopI i dpBase =
          if i > len1 then
            dpBase
          else
            -- process column j for row iw
            let
              loopJ : Int -> Matrix Int -> Matrix Int
              loopJ j dpCurrent =
                if j > len2 then
                  -- move to next row
                  loopI (i + 1) dpCurrent
                else
                  let
                    -- check characters
                    c1 = String.slice (i - 1) i str1
                    c2 = String.slice (j - 1) j str2

                    -- If characters match
                    dpUpdated =
                      if c1 == c2 then
                        -- get diagonal value and add 1
                        let
                          diagVal = getOrDefault (i - 1) (j - 1) dpCurrent
                          newVal = diagVal + 1
                        in
                          Matrix.set i j newVal dpCurrent
                      else
                        -- get max of top and left
                        let
                          topVal = getOrDefault (i - 1) j dpCurrent
                          leftVal = getOrDefault i (j - 1) dpCurrent
                          maxVal = max topVal leftVal
                        in
                          Matrix.set i j maxVal dpCurrent
                  in
                    loopJ (j + 1) dpUpdated
            in
              loopJ 1 dpBase
      in
        loopI 1 dp

  in
    -- Result is bottom-right cell
    getOrDefault len1 len2 filledDP