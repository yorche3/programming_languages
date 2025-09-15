
# Unit Test projects with cobol
How were build unit test projects.

## Requisites
- Install
  - [Cobol](https://gnucobol.sourceforge.io)

## Structure
```text
demo
|-- src
|-- test
|-- Makefile
```

## Build project

## Modify project
Go to `demo` directory and

- write your `libs` `example.cbl` taking this code as base:
```cobol
       identification division.
       program-id. numbers-recursive.
       
       environment division.
           configuration section.
               Source-Computer. UBUNTU2404.
               Object-Computer. UBUNTU2404.
           repository.
               function all intrinsic.
           input-output section.
               file-control.

       data division.
           file section.
           working-storage section.
               01 n pic 99.
               01 result pic 99.
           linkage section.
           report section.
           screen section.

       procedure division.
           display "Hello".
           compute n = 3.
           call 'sum-number' using n result.
           display result.
           stop run.
       end program numbers-recursive.

       identification division.
       program-id. add-number.
       environment division.
           configuration section.
               source-computer. ubuntu2404.
               object-computer. ubuntu2404.
           repository.
               function all intrinsic.
           input-output section.
               file-control.
       data division.
           file section.
           working-storage section.
               01 default_value pic 99 value 5.
           linkage section.
               01 n pic 99.
               01 result pic 99.
           report section.
           screen section.
       procedure division using n result.
            begin.
                compute result = default_value + n.
                goback returning result.
       end program add-number.
```

## Compile and run tests
### Compile
- Por cada programa:
```bash
cobc - o example example.cbl
```
### Run
```bash
./run_tests
```