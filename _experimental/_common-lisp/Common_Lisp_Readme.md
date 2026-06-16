
# Unit Test projects with Forth
How were built unit test projects.

## Requisites
- Install
  - [Forth](https://www.sbcl.org/)
  - [QuickLisp](https://www.quicklisp.org/beta/)
  - []
  - or your prefered options

## Structure
```text
demo
├── src
└── test
    └── run-tests.forth
```

## Configure
- Initialize running:
```bash
rebar3 new app demo
```

## Build project

## Modify project
## Compile and run tests
### Run
```bash
sbcl --load "test/run_tests.lisp" --eval "(run-all::run-all-suites)" --quit
```