       IDENTIFICATION DIVISION.
       PROGRAM-ID. PJSUB001.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IDX-FILE   ASSIGN TO IDXFILE
                             ORGANIZATION INDEXED
                             ACCESS MODE RANDOM
                             RECORD KEY IDX-KEY
                             STATUS IDX-ST.
       DATA DIVISION.
       FILE SECTION.
       FD  IDX-FILE.
         01  IDX-REC.
           03 IDX-KEY.
             05 IDX-ID          PIC S9(5) COMP-3.
             05 IDX-CRN         PIC S9(3) COMP.
           03 IDX-NAME          PIC X(15).
           03 IDX-SRNAME        PIC X(15).
           03 IDX-DATE          PIC S9(7) COMP-3.
           03 IDX-BALANCE       PIC S9(5) COMP-3.
       WORKING-STORAGE SECTION.
         01  WS-WORK-AREA.
           05 IDX-ST            PIC 9(02).
              88 IDX-SUCCES                VALUE 00 97.
           05 WS-PROCESS-TYPE   PIC 9(01).
              88 WS-PROCESS-TYPE-VALID     VALUE 1 THRU 9.
           05 WS-INDEX          PIC 9(02).
           05 WS-RESULT         PIC X(15).
           05 WS-CHAR           PIC X(15).
           05 WS-COUNTER        PIC 9(02).

       LINKAGE SECTION.
       01 WS-SUB-AREA.
           05 SUB-INP-PROCESS-TYPE  PIC 9(01).
           05 SUB-INP-ID            PIC 9(5).
           05 SUB-INP-CRN           PIC 9(3).
           05 SUB-OUT-PROCESS-TYPE  PIC 9(01).
           05 SUB-OUT-ID            PIC 9(05).
           05 SUB-OUT-CRN           PIC 9(03).
           05 SUB-OUT-RETURN-CODE   PIC 9(02).
           05 SUB-OUT-EXPLANATION   PIC X(30).
           05 SUB-OUT-NAME          PIC X(15).
           05 SUB-OUT-SURNAME       PIC X(15).

       PROCEDURE DIVISION USING WS-SUB-AREA.
       0000-MAIN.
           PERFORM H100-OPEN-FILES
           PERFORM H200-PROCCES
           PERFORM H999-PROGRAM-EXIT.
           EXIT PROGRAM.
       0000-END. EXIT.

       H100-OPEN-FILES.
           OPEN I-O IDX-FILE.
           IF (IDX-ST NOT = 0) AND (IDX-ST NOT = 97)
           DISPLAY 'FILE OPEN FAILED: ' IDX-ST
           MOVE IDX-ST TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF
           READ IDX-FILE.
       H100-END. EXIT.

       H200-PROCCES.
           MOVE SUB-INP-ID TO IDX-ID.
           MOVE SUB-INP-CRN TO IDX-CRN.
           READ IDX-FILE KEY IS IDX-KEY
           INVALID KEY
              MOVE SUB-INP-PROCESS-TYPE TO WS-PROCESS-TYPE
              IF WS-PROCESS-TYPE = '3'
                 PERFORM H800-WRITE
              ELSE
                 PERFORM H210-INVALID-KEY
              END-IF
           NOT INVALID KEY PERFORM H220-VALID-KEY.
       H200-END. EXIT.

       H210-INVALID-KEY.
           DISPLAY 'ID DOESNT EXISTS: ' SUB-INP-ID SUB-INP-CRN
           MOVE SUB-INP-PROCESS-TYPE TO SUB-OUT-PROCESS-TYPE
           MOVE SUB-INP-ID         TO SUB-OUT-ID
           MOVE SUB-INP-CRN        TO SUB-OUT-CRN
           MOVE IDX-ST         TO SUB-OUT-RETURN-CODE
           STRING 'ID INVALID,UNSUCCESSFUL, RC:' IDX-ST
               DELIMITED BY SIZE INTO SUB-OUT-EXPLANATION
           MOVE '***************'       TO SUB-OUT-NAME
           MOVE '***************'     TO SUB-OUT-SURNAME
           DISPLAY 'INVALID ID: ' SUB-INP-ID SUB-INP-CRN
           DISPLAY ' '.
       H210-END. EXIT.

       H220-VALID-KEY.
           MOVE SUB-INP-PROCESS-TYPE TO WS-PROCESS-TYPE
           EVALUATE TRUE
              WHEN WS-PROCESS-TYPE = '1'
                PERFORM H700-READ
              WHEN WS-PROCESS-TYPE = '2'
                PERFORM H750-DELETE
              WHEN WS-PROCESS-TYPE = '3'
                PERFORM H810-WRITE-NOT
              WHEN WS-PROCESS-TYPE = '4'
                PERFORM H500-UPDATE
              WHEN OTHER
              DISPLAY 'WRONG PROCESS TYPE'
           END-EVALUATE.
       H220-END. EXIT.

       H700-READ.
           DISPLAY 'I AM IN READ FUNCTION'
           MOVE SUB-INP-PROCESS-TYPE TO SUB-OUT-PROCESS-TYPE
           MOVE SUB-INP-ID         TO SUB-OUT-ID
           MOVE SUB-INP-CRN        TO SUB-OUT-CRN
           MOVE IDX-ST         TO SUB-OUT-RETURN-CODE
           STRING 'READING FILE SUCCESSFUL, RC:' IDX-ST
               DELIMITED BY SIZE INTO SUB-OUT-EXPLANATION
           MOVE IDX-NAME       TO SUB-OUT-NAME
           MOVE IDX-SRNAME     TO SUB-OUT-SURNAME
           DISPLAY 'READING ID: ' SUB-INP-ID SUB-INP-CRN
           DISPLAY 'END OF READ FUNCTION'
           DISPLAY ' '.
       H700-END. EXIT.

       H750-DELETE.
           DISPLAY 'I AM IN DELETE FUNCTION'
           MOVE SUB-INP-PROCESS-TYPE TO SUB-OUT-PROCESS-TYPE
           MOVE SUB-INP-ID         TO SUB-OUT-ID
           MOVE SUB-INP-CRN        TO SUB-OUT-CRN
           MOVE IDX-ST         TO SUB-OUT-RETURN-CODE
           STRING 'DELETE FILE SUCCESSFUL,  RC:' IDX-ST
               DELIMITED BY SIZE INTO SUB-OUT-EXPLANATION
           MOVE IDX-NAME       TO SUB-OUT-NAME
           MOVE IDX-SRNAME     TO SUB-OUT-SURNAME
           DELETE IDX-FILE RECORD
           END-DELETE
           DISPLAY 'DELETED ID: ' SUB-INP-ID SUB-INP-CRN
           DISPLAY 'END OF DELETE FUNCTION'
           DISPLAY ' '.
       H750-END. EXIT.

       H800-WRITE.
           DISPLAY 'I AM IN WRITE FUNCTION'
           MOVE ZEROES TO IDX-ID
           MOVE ZEROES TO IDX-CRN
           MOVE 'NEWNAME' TO IDX-NAME
           MOVE 'NEWSURNAME' TO IDX-SRNAME
           MOVE ZEROES TO IDX-DATE
           MOVE ZEROES TO IDX-BALANCE
           WRITE IDX-REC
           END-WRITE.
           MOVE 0 TO SUB-OUT-PROCESS-TYPE
           MOVE 00000 TO SUB-OUT-ID
           MOVE 000 TO SUB-OUT-CRN
           MOVE 00 TO SUB-OUT-RETURN-CODE
           STRING 'WRITING FILE SUCCESSFUL, RC:' IDX-ST
               DELIMITED BY SIZE INTO SUB-OUT-EXPLANATION
           MOVE 'NEWNAME' TO SUB-OUT-NAME
           MOVE 'NEWSURNAME' TO SUB-OUT-SURNAME
           DISPLAY 'WRITTEN ID: ' SUB-INP-ID SUB-INP-CRN
           DISPLAY 'END OF WRITE FUNCTION'
           DISPLAY ' '.
       H800-END. EXIT.

       H810-WRITE-NOT.
           DISPLAY 'I AM IN NOT-WRITE FUNCTION'
           DISPLAY  'ID ALREADY EXISTS: ' SUB-INP-ID SUB-INP-CRN
           MOVE SUB-INP-PROCESS-TYPE TO SUB-OUT-PROCESS-TYPE
           MOVE SUB-INP-ID         TO SUB-OUT-ID
           MOVE SUB-INP-CRN        TO SUB-OUT-CRN
           MOVE IDX-ST         TO SUB-OUT-RETURN-CODE
           STRING 'ID EXISTS, UNSUCCESSFUL, RC:' IDX-ST
               DELIMITED BY SIZE INTO SUB-OUT-EXPLANATION
           MOVE IDX-NAME       TO SUB-OUT-NAME
           MOVE IDX-SRNAME     TO SUB-OUT-SURNAME
           DISPLAY 'END OF NOT-WRITE FUNCTION'
           DISPLAY ' '.
       H810-END. EXIT.

       H500-UPDATE.
           DISPLAY 'I AM IN UPDATE FUNCTION'
           DISPLAY 'BEFORE UPDATE NAME: ' IDX-NAME
           MOVE IDX-NAME TO WS-RESULT
           PERFORM H510-UPDATE-FUNC
           DISPLAY 'END OF UPDATE FUNCTION'
           DISPLAY ' '.
       H500-END. EXIT.

       H510-UPDATE-FUNC.
           MOVE 1 TO WS-COUNTER
           MOVE 1 TO WS-INDEX
           MOVE SPACES TO IDX-NAME
           PERFORM UNTIL WS-COUNTER >= 15
              MOVE WS-RESULT(WS-COUNTER:1) TO WS-CHAR
              IF WS-CHAR NOT = ' '
                 MOVE WS-CHAR TO IDX-NAME(WS-INDEX:1)
                 ADD 1 TO WS-INDEX
              END-IF
              ADD 1 TO WS-COUNTER
           END-PERFORM
           DISPLAY 'AFTER UPDATE NAME: ' IDX-NAME
           DISPLAY 'BEFORE UPDATE SURNAME: '
           INSPECT IDX-SRNAME REPLACING
           ALL 'E' BY 'I',
           'A' BY 'E'.
           REWRITE IDX-REC.
           DISPLAY 'AFTER UPDATE SURNAME: ' IDX-SRNAME

           MOVE SUB-INP-PROCESS-TYPE TO SUB-OUT-PROCESS-TYPE
           MOVE SUB-INP-ID TO SUB-OUT-ID
           MOVE SUB-INP-CRN TO SUB-OUT-CRN
           MOVE IDX-ST TO SUB-OUT-RETURN-CODE
           STRING 'UPDATE FILE SUCCESSFUL,  RC:' IDX-ST
               DELIMITED BY SIZE INTO SUB-OUT-EXPLANATION
           MOVE IDX-NAME TO SUB-OUT-NAME
           MOVE IDX-SRNAME TO SUB-OUT-SURNAME.
       H510-END. EXIT.

       H999-PROGRAM-EXIT.
           CLOSE IDX-FILE.
       H999-END. EXIT.
      *