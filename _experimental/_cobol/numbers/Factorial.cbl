              IDENTIFICATION DIVISION.
       PROGRAM-ID. FACTORIAL.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 I PIC 99.
       01 ACC PIC 9(9).
       01 TEMP PIC 9(9).
           LINKAGE SECTION.
           01 N PIC 99.
           01 RESULT PIC 9(9).

       PROCEDURE DIVISION USING N RESULT.
           IF N < 2
               MOVE 1 TO RESULT
           ELSE
               MOVE 1 TO ACC
               PERFORM VARYING I FROM 2 BY 1 UNTIL I > N
                   COMPUTE TEMP = I * ACC
                   MOVE TEMP TO ACC
               END-PERFORM
               MOVE ACC TO RESULT
           END-IF.
           EXIT.
