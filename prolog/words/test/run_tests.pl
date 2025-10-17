#!/usr/bin/env swipl
  
:- use_module(library(plunit)).
:- consult('./words_test.pl').

:- initialization(main, program).

main :-
    run_tests,
    halt.