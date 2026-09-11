       IDENTIFICATION DIVISION.
       PROGRAM-ID. CALCULATOR.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 NUM1        PIC 9(5) VALUE 0.
       01 NUM2        PIC 9(5) VALUE 0.
       01 RESULT      PIC 9(10) VALUE 0.

       LINKAGE SECTION.
       01 LINK-NUM1   PIC 9(5).
       01 LINK-NUM2   PIC 9(5).
       01 LINK-RESULT PIC 9(10).

       PROCEDURE DIVISION.
       
      *> cobol-lint CL002 addition
       ADDITION.
           ADD LINK-NUM1 TO LINK-NUM2 GIVING LINK-RESULT.
           EXIT.
       
      *> cobol-lint CL002 substraction
       SUBSTRACTION.
           ADD LINK-NUM1 TO LINK-NUM2 GIVING LINK-RESULT.
           EXIT.

       END PROGRAM CALCULATOR.
