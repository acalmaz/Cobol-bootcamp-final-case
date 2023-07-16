# Cobol-bootcamp-final-case
Patika, AKBANK COBOL Bootcamp Bitirme Projesi,
Projeyi yapmaya main programdan başladım. USING komutunu ekleyerek gerekli veri aktarımını yapıp bir subprogram çağırdım. 

    <H200-PROCCES.
           PERFORM H300-INP-SUB
           CALL WS-SUBPROG USING WS-SUB-AREA
           PERFORM H400-OUT-SUB
           READ INP-FILE.
       H200-END. EXIT.>                

Main program yalnızca dosya işlemlerini gerçekleştirdiğimiz alan olduğu için input ve output dosya verilerini burada işleme soktum. 


    <FILE SECTION.
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
           03 INP-CRN           PIC 9(3). >

Subprogramda ise VSAM dosyasını tanımlayarak,dosyada olması gereken,
  -READ,
  -WRITE,
  -DELETE ve
  -UPDATE işlemleri için fonksiyonlar yazdım ve tüm processleri burada gerçekleştirdim.

      <H220-VALID-KEY.
           MOVE SUB-INP-PROCESS-TYPE TO WS-PROCESS-TYPE
           EVALUATE TRUE
              WHEN WS-PROCESS-TYPE = '1'
                PERFORM H300-READ
              WHEN WS-PROCESS-TYPE = '2'
                PERFORM H400-DELETE
              WHEN WS-PROCESS-TYPE = '3'
                PERFORM H510-WRITE-VALID
              WHEN WS-PROCESS-TYPE = '4'
                PERFORM H600-UPDATE
              WHEN OTHER
              DISPLAY 'WRONG PROCESS TYPE'
           END-EVALUATE.
       H220-END. EXIT.>          

  Kullanmamız gereken,
    -Set, 
    -Inspect, 
    -String ve 
    -Evaluate komutlarını yine Subprogramda gerekli yerlerde kullandım.

      <SET IDX-SUCCES TO TRUE>
      
         <INSPECT IDX-SRNAME REPLACING
           ALL 'E' BY 'I',
           'A' BY 'E'.>
           
         <STRING 'UPDATE FILE SUCCESSFUL, RC:' IDX-ST ' '
               DELIMITED BY SIZE INTO SUB-OUT-EXPLANATION>
               
          <EVALUATE TRUE
              WHEN WS-PROCESS-TYPE = '1'
                PERFORM H300-READ
              WHEN WS-PROCESS-TYPE = '2'
                PERFORM H400-DELETE
              WHEN WS-PROCESS-TYPE = '3'
                PERFORM H510-WRITE-VALID
              WHEN WS-PROCESS-TYPE = '4'
                PERFORM H600-UPDATE
              WHEN OTHER
              DISPLAY 'WRONG PROCESS TYPE'
           END-EVALUATE.>

  JCL dosyalarında ödev 3 de olduğu gibi kullanılacak input dosyaları için 3 jcl çalıştırdım. İnputları aldıktan sonra CBL dosyalarının 
    çalışması için yazdığım JCL'de önce subprogramı derledim ardından main programı derledim ve main dosyasını çalıştırdım.

  Return Code değerim 0000 olduğu için hatasız bir çalışma gerçekleşti.
  Gerekli çıktıları kontrol ettim ve biraz daha düzenli durması için subprogramda bazı değişiklikler yaptım.
  Bu şekilde projemi sonlandırdım.
  Tüm dosyalar repoda mevcut.
  Teşekkürler :).
  
