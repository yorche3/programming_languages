reverse_string(String, ReversedString) :-
    string_chars(String, Chars),
    reverse_list_acc(Chars, [], ReversedChars),
    string_chars(ReversedString, ReversedChars).

reverse_list_acc([], Acc, Acc).
reverse_list_acc([H|T], Acc, Reversed) :-
    reverse_list_acc(T, [H|Acc], Reversed).

remove_whitespace([], []).
remove_whitespace([H|T], Result) :-
    member(H, [' ', '\t', '\n', '\r']),
    remove_whitespace(T, Result).
remove_whitespace([H|T], [H|Result]) :-
    \+ member(H, [' ', '\t', '\n', '\r']),
    remove_whitespace(T, Result).

is_palindrome(String, Response) :-
    string_chars(String, Chars),
    remove_whitespace(Chars, SanitizedChars),
    reverse_list_acc(SanitizedChars, [], ReversedChars),
    ( SanitizedChars == ReversedChars ->
        Response is 1
    ;   Response is 0
    ).

compute_lps_array(Pat, Lps) :-
    string_chars(Pat, Chars),
    compute_lps_loop(Chars, 1, 0, [0], RevLps),
    reverse(RevLps, Lps).

compute_lps_loop(Chars, Index, _, Acc, Acc) :-
    length(Chars, Len),
    Index >= Len.
compute_lps_loop(Chars, Index, Length, Acc, FinalLps) :-
    nth0(Index, Chars, CharAtIndex),
    nth0(Length, Chars, CharAtLength),
    ( CharAtIndex == CharAtLength ->
        NewLength is Length + 1,
        NewIndex is Index + 1,
        compute_lps_loop(Chars, NewIndex, NewLength, [NewLength|Acc], FinalLps)
    ; Length > 0 ->
        PrevLpsValIndex is Length - 1,
        reverse(Acc, CurrentLps),
        nth0(PrevLpsValIndex, CurrentLps, NewLength),
        compute_lps_loop(Chars, Index, NewLength, Acc, FinalLps)
    ; 
        NewIndex is Index + 1,
        compute_lps_loop(Chars, NewIndex, 0, [0|Acc], FinalLps)
    ).

kmp_search(Pat, Txt, Response) :-
    string_chars(Pat, PatChars),
    string_chars(Txt, TxtChars),
    length(PatChars, LenPat),
    length(TxtChars, LenTxt),
    ( LenPat == 0 ->
        Response is 1
    ; LenPat > LenTxt ->
        Response is 0
    ; 
        compute_lps_array(Pat, Lps),
        kmp_loop(PatChars, TxtChars, LenPat, LenTxt, 0, 0, Lps, Response)
    ).

kmp_loop(_, _, LenPat, _, _, LenPat, _, 1).
kmp_loop(_, _, _, LenTxt, LenTxt, _, _, 0).
kmp_loop(PatChars, TxtChars, LenPat, LenTxt, I, J, Lps, Boolean) :-
    nth0(I, TxtChars, TxtChar),
    nth0(J, PatChars, PatChar),
    ( TxtChar == PatChar ->
        NewI is I + 1,
        NewJ is J + 1,
        kmp_loop(PatChars, TxtChars, LenPat, LenTxt, NewI, NewJ, Lps, Boolean)
    ; J > 0 ->
        Index is J - 1,
        nth0(Index, Lps, LpsVal),
        kmp_loop(PatChars, TxtChars, LenPat, LenTxt, I, LpsVal, Lps, Boolean)
    ;
        NewI is I + 1,
        kmp_loop(PatChars, TxtChars, LenPat, LenTxt, NewI, J, Lps, Boolean)
    ).

matrix_new(Rows, Cols, InitialValue, Matrix) :-
    length(Matrix, Rows),            % Create a list with 'Rows' elements
    length(InitialRow, Cols),        % Create a list for a row with 'Cols' elements
    maplist(=(InitialValue), InitialRow), % Fill the initial row with 'InitialValue'
    maplist(=(InitialRow), Matrix).  % Fill each row of the matrix with the initial row

matrix_get(Matrix, RowIndex, ColIndex, Element) :-
    nth0(RowIndex, Matrix, Row),     % Get the specified row
    nth0(ColIndex, Row, Element).    % Get the element from the row

matrix_set(Matrix, RowIndex, ColIndex, NewValue, NewMatrix) :-
    nth0(RowIndex, Matrix, OldRow, RestOfMatrix), % Get the old row and the rest of the matrix
    nth0(ColIndex, OldRow, _, RestOfOldRow),      % Get the rest of the old row after the element
    nth0(ColIndex, NewRow, NewValue, RestOfOldRow), % Create the new row with the updated element
    nth0(RowIndex, NewMatrix, NewRow, RestOfMatrix). % Create the new matrix with the updated row


lcs(Str1, Str2, Length) :-
    string_chars(Str1, Chars1),
    string_chars(Str2, Chars2),
    length(Chars1, Len1),
    length(Chars2, Len2),
    N is Len1 + 1,
    M is Len2 + 1,
    matrix_new(N, M, 0, DP),
    lcs_loop(1, 1, Len1, Len2, Chars1, Chars2, DP, Length).

lcs_loop(I, J, LenStr1, LenStr2, Str1, Str2, DP, Length) :-
    ( I > LenStr1 ->
        matrix_get(DP, LenStr1, LenStr2, Length)
    ; J > LenStr2 ->
        NewI is I + 1,
        lcs_loop(NewI, 1, LenStr1, LenStr2, Str1, Str2, DP, Length)
    ; 
        Index1 is I - 1,
        Index2 is J - 1,
        nth0(Index1, Str1, Char1),
        nth0(Index2, Str2, Char2),
        NewJ is J + 1,
        ( Char1 == Char2 ->
            matrix_get(DP, Index1, Index2, PrevLength),
            NewLength is PrevLength + 1,
            matrix_set(DP, I, J, NewLength, NewDP),
            lcs_loop(I, NewJ, LenStr1, LenStr2, Str1, Str2, NewDP, Length)
        ;
            matrix_get(DP, Index1, J, PrevLength1),
            matrix_get(DP, I, Index2, PrevLength2),
            NewLength is max(PrevLength1, PrevLength2),
            matrix_set(DP, I, J, NewLength, NewDP),
            lcs_loop(I, NewJ, LenStr1, LenStr2, Str1, Str2, NewDP, Length)
        )
    ).