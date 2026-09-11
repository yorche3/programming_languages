-module(words).

-export([reverse_string/1, is_palindrome/1, kmp_search/2, lcs/2]).

reverse_string(Str) ->
  reverse_helper(Str, []).

reverse_helper([], Buffer) ->
  Buffer;
reverse_helper([H | T], Buffer) ->
  reverse_helper(T, [H | Buffer]).

is_palindrome(Str) ->
  CleanedStr = re:replace(Str, "\\s+", "", [global, {return, list}]),
  CleanedStr == reverse_string(CleanedStr).

compute_lps_array(Str) ->
  LenStr = length(Str),
  Lps = array:new(LenStr, [{default, 0}]),
  update_lps(1, 0, Lps, Str, LenStr).

update_lps(I, Len, Lps, Str, LenStr) ->
  if
    I >= LenStr ->
      Lps;
    true ->
      StrBinary = list_to_binary(Str),
      CharI = binary:part(StrBinary, I, 1),
      CharLen = binary:part(StrBinary, Len, 1),
      if
        CharI == CharLen ->
          LpsUpdated = array:set(I, Len + 1, Lps),
          update_lps(I + 1, Len + 1, LpsUpdated, Str, LenStr);
        true ->
          if
            Len > 0 ->
              PrevLen = array:get(Len - 1, Lps),
              update_lps(I, PrevLen, Lps, Str, LenStr);
            true ->
              LpsUpdated = array:set(I, 0, Lps),
              update_lps(I + 1, Len, LpsUpdated, Str, LenStr)
          end
      end
  end.

kmp_search(Sub, Str) ->
  LenSub = length(Sub),
  LenStr = length(Str),
  if 
    LenSub == 0 -> 
      true;
    LenSub > LenStr -> 
      false;
    true ->
      Lps = compute_lps_array(Sub),
      kmp_loop(0, 0, Sub, Str, LenSub, LenStr, Lps)
  end.

kmp_loop(I, J, Sub, Str, LenSub, LenStr, Lps) ->
  if
    J == LenSub ->
      true;
    I >= LenStr ->
      false;
    true ->
      StrBinary = list_to_binary(Str),
      SubBinary = list_to_binary(Sub),
      CharStr = binary:part(StrBinary, I, 1),
      CharSub = binary:part(SubBinary, J, 1),
      if
        CharStr == CharSub ->
          kmp_loop(I + 1, J + 1, Sub, Str, LenSub, LenStr, Lps);
        true ->
          if
            J > 0 ->
              NewJ = array:get(J - 1, Lps),
              kmp_loop(I, NewJ, Sub, Str, LenSub, LenStr, Lps);
            true ->
              kmp_loop(I + 1, J, Sub, Str, LenSub, LenStr, Lps)
          end
      end
  end.

lcs(Str1, Str2) ->
  Len1 = length(Str1),
  Len2 = length(Str2),
  if
    (Len1 == 0) orelse (Len2 == 0) -> 
      0;
    true ->
      Size = (Len1 + 1) * (Len2 + 1),
      Dp = array:new(Size, [{default, 0}]),
      FinalDp = for_i(1, Str1, Str2, Len1, Len2, Dp),
      Index = Len1 * (Len2 + 1) + Len2,
      array:get(Index, FinalDp)
  end.

for_i(I, Str1, Str2, Len1, Len2, Dp) ->
  if
    I > Len1 ->
      Dp;
    true ->
      DpUpdated = for_j(I, 1, Str1, Str2, Len1, Len2, Dp),
      for_i(I + 1, Str1, Str2, Len1, Len2, DpUpdated)
  end.

for_j(I, J, Str1, Str2, Len1, Len2, Dp)->
  if
    J > Len2 ->
      Dp;
    true ->
      Str1Binary = list_to_binary(Str1),
      Str2Binary = list_to_binary(Str2),
      Char1 = binary:part(Str1Binary, I - 1, 1),
      Char2 = binary:part(Str2Binary, J - 1, 1),
      IndexCurr = I * (Len2 + 1) + J,
      IndexPrevRowCol = (I - 1) * (Len2 + 1) + (J - 1),
      IndexPrevRow = (I - 1) * (Len2 + 1) + J,
      IndexPrevCol = I * (Len2 + 1) + (J - 1),
      if
        Char1 == Char2 ->
          MatchVal = array:get(IndexPrevRowCol, Dp),
          DpUpdated = array:set(IndexCurr, MatchVal + 1, Dp),
          for_j(I, J + 1, Str1, Str2, Len1, Len2, DpUpdated);
        true ->
          Val1 = array:get(IndexPrevRow, Dp),
          Val2 = array:get(IndexPrevCol, Dp),
          MaxVal = max(Val1, Val2),
          DpUpdated = array:set(IndexCurr, MaxVal, Dp),
          for_j(I, J + 1, Str1, Str2, Len1, Len2, DpUpdated)
      end
  end.
