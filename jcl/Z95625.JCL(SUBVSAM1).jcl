//SUBVSAM1 JOB 1,CLASS=A,MSGLEVEL=(1,1),MSGCLASS=X,NOTIFY=&SYSUID
//DELET500 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE Z95625.VSAM.CC CLUSTER PURGE
  IF LASTCC LE 08 THEN SET MAXCC = 00
  DEF CL ( NAME(Z95625.VSAM.CC)    -
  FREESPACE( 20 20 )               -
  SHR( 2,3 )                       -
  KEYS(5 0)                        -
  INDEXED SPEED                    -
  RECSZ(42 42)                     -
  TRK (10 10)                      -
  LOG(NONE)                        -
  VOLUMES (VPWRKB)                 -
  UNIQUE )                         -
  DATA (NAME(Z95625.VSAM.CC.DATA)) -
  INDEX (NAME(Z95625.VSAM.CC.INDEX))
//REPRO600 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//OUT001   DD DSN=Z95625.VSAM.CC,DISP=SHR
//INN001   DD DSN=Z95625.QSAM.ZZ,DISP=SHR
//SYSIN    DD *
  REPRO INFILE(INN001) OUTFILE(OUT001)