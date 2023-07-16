       IDENTIFICATION DIVISION.
       PROGRAM-ID. PJMAIN01.
       AUTHOR. AHMET MELIH CALMAZ.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INP-FILE ASSIGN TO INPFILE
                             STATUS INP-ST.
           SELECT OUT-FILE   ASSIGN TO OUTFILE
                             STATUS OUT-ST.

       DATA DIVISION.
       FILE SECTION.
       FD  OUT-FILE RECORDING MODE F.
         01  OUT-REC.
           05 OUT-PROCESS-TYPE  PIC 9(01).
           05 OUT-ID            PIC 9(05).
           05 OUT-CRN           PIC 9(03).
           05 OUT-RETURN-CODE   PIC 9(02).
           05 OUT-EXPLANATION   PIC X(30).
           05 OUT-NAME          PIC X(15).
           05 OUT-SURNAME       PIC X(15).
       FD  INP-FILE RECORDING MODE F.
         01  INP-REC.
           03 INP-PROCESS-TYPE  PIC 9(01).
           03 INP-ID            PIC 9(5).
           03 INP-CRN           PIC 9(3).

       WORKING-STORAGE SECTION.
         01  WS-WORK-AREA.
           05 WS-SUBPROG        PIC X(08)  VALUE 'PJSUB001'.
           05 INP-ST            PIC 9(02).
              88 INP-EOF                   VALUE 10.
              88 INP-SUCCES                VALUE 00 97.
           05 OUT-ST            PIC 9(02).
              88 OUT-SUCCESS               VALUE 00 97.
           05 WS-SUB-AREA.
              07 SUB-INP-PROCESS-TYPE  PIC 9(01).
              07 SUB-INP-ID            PIC 9(5).
              07 SUB-INP-CRN           PIC 9(3).
              07 SUB-OUT-PROCESS-TYPE  PIC 9(01).
              07 SUB-OUT-ID            PIC 9(05).
              07 SUB-OUT-CRN           PIC 9(03).
              07 SUB-OUT-RETURN-CODE   PIC 9(02).
              07 SUB-OUT-EXPLANATION   PIC X(30).
              07 SUB-OUT-NAME          PIC X(15).
              07 SUB-OUT-SURNAME       PIC X(15).


       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM H100-OPEN-FILES
           PERFORM H200-PROCCES UNTIL INP-EOF
           PERFORM H999-PROGRAM-EXIT.
           STOP RUN.
       0000-END. EXIT.

       H100-OPEN-FILES.
           OPEN INPUT  INP-FILE.
           OPEN OUTPUT OUT-FILE.
           IF (INP-ST NOT = 0) AND (INP-ST NOT = 97)
           DISPLAY 'UNABLE TO OPEN INPFILE: ' INP-ST
           MOVE INP-ST TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
           SET INP-SUCCES TO TRUE
           IF (OUT-ST NOT = 0) AND (OUT-ST NOT = 97)
           DISPLAY 'UNABLE TO OPEN OUTFILE: ' OUT-ST
           MOVE OUT-ST TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
           SET OUT-SUCCESS TO TRUE
           READ INP-FILE.
       H100-END. EXIT.

       H200-PROCCES.
           PERFORM H300-INP-SUB
           CALL WS-SUBPROG USING WS-SUB-AREA
           PERFORM H400-OUT-SUB
           READ INP-FILE.
       H200-END. EXIT.

       H300-INP-SUB.
           MOVE INP-PROCESS-TYPE TO SUB-INP-PROCESS-TYPE
           MOVE INP-ID TO SUB-INP-ID
           MOVE INP-CRN TO SUB-INP-CRN.
       H300-END. EXIT.

       H400-OUT-SUB.
           MOVE SUB-OUT-PROCESS-TYPE TO OUT-PROCESS-TYPE
           MOVE SUB-OUT-ID TO OUT-ID
           MOVE SUB-OUT-CRN TO OUT-CRN
           MOVE SUB-OUT-RETURN-CODE TO OUT-RETURN-CODE
           MOVE SUB-OUT-EXPLANATION TO OUT-EXPLANATION
           MOVE SUB-OUT-NAME TO OUT-NAME
           MOVE SUB-OUT-SURNAME TO OUT-SURNAME
           WRITE OUT-REC
           END-WRITE.
       H400-END. EXIT.

       H999-PROGRAM-EXIT.
           CLOSE INP-FILE.
           CLOSE OUT-FILE.
      *
