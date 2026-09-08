hellouser :-
    write('Enter your name: '),
    read_line_to_string(current_input, Name),

    format('Hello, ~w!~n', [Name]).