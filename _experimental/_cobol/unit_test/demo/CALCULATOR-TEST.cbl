       IDENTIFICATION DIVISION.
       PROGRAM-ID. CALCULATOR-TEST.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 TEST-NUM1       PIC 9(5).
       01 TEST-NUM2       PIC 9(5).
       01 EXPECTED-RESULT PIC 9(10).
       01 ACTUAL-RESULT   PIC 9(10).

       *>
       01 LINK-NUM1       PIC 9(5).
       01 LINK-NUM2       PIC 9(5).
       01 LINK-RESULT     PIC 9(10).

       PROCEDURE DIVISION.
       
       *> cobol-lint CL002 test-addition
       TEST-ADDITION.
           MOVE 10 TO TEST-NUM1.
           MOVE 5 TO TEST-NUM2.
           MOVE TEST-NUM1 TO LINK-NUM1.
           MOVE TEST-NUM2 TO LINK-NUM2.
           CALL 'ADDITION' USING LINK-NUM1 LINK-NUM2 LINK-RESULT 
               GIVING ACTUAL-RESULT ENTRY "ADDITION".
           MOVE 15 TO EXPECTED-RESULT.
           IF ACTUAL-RESULT = EXPECTED-RESULT
               DISPLAY "Addition Test Passed."
           ELSE
               DISPLAY "Addition Test Failed. Got: " ACTUAL-RESULT 
               " Expected: " EXPECTED-RESULT
           END-IF.
           EXIT.

      *> cobol-lint CL002 test-substraction
       TEST-SUBSTRACTION.
           MOVE 10 TO TEST-NUM2.
           MOVE 5 TO TEST-NUM1.
           MOVE TEST-NUM1 TO LINK-NUM1.
           MOVE TEST-NUM2 TO LINK-NUM2.
           CALL 'SUBSTRACTION' USING LINK-NUM1 LINK-NUM2 LINK-RESULT
                GIVING ACTUAL-RESULT ENTRY "SUBSTRACTION".
           MOVE 5 TO EXPECTED-RESULT.
           IF ACTUAL-RESULT = EXPECTED-RESULT
               DISPLAY "Subtraction Test Passed."
           ELSE
               DISPLAY "Subtraction Test Failed. Got: " ACTUAL-RESULT 
               " Expected: " EXPECTED-RESULT
           END-IF.
           EXIT.

       END PROGRAM CALCULATOR-TEST.
