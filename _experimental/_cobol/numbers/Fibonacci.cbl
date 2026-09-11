       IDENTIFICATION DIVISION.
       PROGRAM-ID. FIBONACCI.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 I PIC 99.
       01 ACC2 PIC 9(9).
       01 ACC1 PIC 9(9).
       01 TEMP PIC 9(9).
           LINKAGE SECTION.
           01 N PIC 99.
           01 RESULT PIC 9(9).

       PROCEDURE DIVISION USING N RESULT.
           IF N < 1
               MOVE 0 TO RESULT
           ELSE IF N = 1
               MOVE 1 TO RESULT
           ELSE
               MOVE 0 TO ACC2
               MOVE 1 TO ACC1
               PERFORM VARYING I FROM 2 BY 1 UNTIL I > N
                   COMPUTE TEMP = ACC1 + ACC2
                   MOVE ACC1 TO ACC2
                   MOVE TEMP TO ACC1
               END-PERFORM
               MOVE ACC1 TO RESULT
           END-IF.
           EXIT.
