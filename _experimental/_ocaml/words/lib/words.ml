let reverse_string str =
  let len_str = String.length str in
  if len_str <= 1
  then str
  else
    let buff = Buffer.create len_str in
    for i = len_str - 1 downto 0 do
      Buffer.add_char buff str.[i]
    done;
    Buffer.contents buff

let is_palindrome str =
  let cleaned_str = Str.global_replace (Str.regexp "[ \t\n\r\x0C]+") "" str in
  let rec loop i j =
    if i >= j then true
    else if cleaned_str.[i] <> cleaned_str.[j] then false
    else loop (i + 1) (j - 1)
  in
  loop 0 (String.length cleaned_str - 1)

let compute_lps_array (patt : string) : int array =
  let len_patt = String.length patt in
  let lps = Array.make len_patt 0 in
  let rec lps_loop i len =
    if i >= len_patt then ()
    else
      if patt.[i] = patt.[len] then
        begin
          lps.(i) <- len + 1;
          lps_loop (i + 1) (len + 1)
        end
      else if len > 0 then
          lps_loop i (len - 1)
      else
        lps_loop (i + 1) len in
  lps_loop 1 0;
  lps

let kmp_search sub str =
  let len_sub = String.length sub in
  let len_str = String.length str in
  if len_sub = 0
  then true
  else if len_sub > len_str
  then false
  else
    let lps = compute_lps_array sub in
    let rec kmp_loop i j =
      if j = len_sub then true
      else if i >= len_str then false
      else if str.[i] = sub.[j] then kmp_loop (i + 1) (j + 1)
      else if j > 0 then kmp_loop i lps.(j - 1)
      else kmp_loop (i + 1) j
    in
    kmp_loop 0 0

let lcs str1 str2 =
  let len1 = String.length str1 in
  let len2 = String.length str2 in
  let dp = Array.make_matrix (len1 + 1) (len2 + 1) 0 in
  for i = 1 to len1 do
    for j = 1 to len2 do
      if str1.[i - 1] == str2.[j - 1]
      then dp.(i).(j) <- dp.(i - 1).(j - 1) + 1
      else dp.(i).(j) <- max dp.(i - 1).(j) dp.(i).(j - 1)
    done;
  done;
  dp.(len1).(len2)

let max a b =
  if a > b then a
  else b