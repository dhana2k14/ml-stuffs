*DO IF(Town='').
*COMPUTE Town=Sub1.
*Else IF(Town='' AND Sub2<>'').
*COMPUTE Town=Sub2.
*END IF.

STRING Suburb (A50).
DO IF (Sub1<>'').
COMPUTE Suburb=Sub1.
ELSE IF(Suburb='' AND Sub2<>'').
COMPUTE Suburb=Sub2.
END IF.

COMPUTE Rvi = FinalValue/PreviousValue.

IF(PrUse='') PrUse=FinUse.


STRING File (A10).
DO IF(PrUse='A01' or PrUse='A02' or PrUse='A03' or PrUse='A04' or PrUse='A05' or PrUse='A06' or PrUse='B18' or PrUse='B23' or PrUse='D05' or PrUse='D08' or PrUse='D09').
COMPUTE File='SR'.
ELSE IF (PrUse='K03' or PrUse='K04' or PrUse='K05' or PrUse='K06' or PrUse='K07' or PrUse='K10').
COMPUTE File='VL'.
ELSE IF (PrUse='J01' or PrUse='J02' or PrUse='J03' or PrUse='J04' or PrUse='J05' or PrUse='J06' or PrUse='J07' or PrUse='J08' or PrUse='J09' or PrUse='J10' or PrUse='J11' or PrUse='J12').
COMPUTE File='VL'.
ELSE IF (PrUse='G01' or PrUse='G02' or PrUse='G03' or PrUse='G04' or PrUse='G05' or PrUse='G06' or PrUse='G07' or PrUse='G08' or PrUse='G09' or PrUse='G10' or PrUse='G11' or PrUse='G12' or PrUse='G13' or PrUse='G14').
COMPUTE File='AG'.
ELSE IF (PrUse='I08' or PrUse='I09' or PrUse='I10' or PrUse='I11' or PrUse='I12' or PrUse='I13' or PrUse='I14' or PrUse='I15' or PrUse='I16').
COMPUTE File='PS'.
ELSE IF (PrUse='').
COMPUTE File='NR'.
END IF.

