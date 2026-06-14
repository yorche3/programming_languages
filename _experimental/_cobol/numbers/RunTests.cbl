       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAINPROGRAM.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 N PIC 99.
       01 RESULT PIC 9(9).
       PROCEDURE DIVISION.
           MOVE 5 TO N.
           CALL 'FIBONACCI' USING N, RESULT.
           IF RESULT = 5
               DISPLAY "Fibonacci... PASS"
           ELSE
               DISPLAY "Fibonacci... FAIL"
           END-IF.
           CALL 'FACTORIAL' USING N, RESULT.
           IF RESULT = 120
               DISPLAY "Factorial... PASS"
           ELSE
               DISPLAY "Factorial... FAIL"
           END-IF.
           CALL 'SUMNUMBERS' USING N, RESULT.
           IF RESULT = 15
               DISPLAY "SumNumbers... PASS"
           ELSE
               DISPLAY "SumNumbers... FAIL"
           END-IF.
           STOP RUN.
