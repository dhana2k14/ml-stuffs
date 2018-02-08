begin program.
import spssaux
for var in spssaux.GetVariableNamesList():
           print var
end program.

* Regression loop over different dependent variables.

begin program.
dependent ='v1' 
independent='v4 to v14'
import spss,spssaux
deplist=spssaux.VariableDict(caseless=True).expand(dependent)
indlist=spssaux.VariableDict(caseless=True).expand(independent)
for dep in deplist:
      spss.Submit('''
REGRESSION
/MISSING PAIRWISE
/STATISTICS COEFF OUTS R ANOVA
/CRITERIA=PIN(.05) POUT(.10)
/NOORIGIN
/DEPENDENT %s
/METHOD=STEPWISE %s.
'''%(dep,' '.join(indlist)))
end program.


REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT v1
  /METHOD=STEPWISE v8
  /METHOD=ENTER v12
  /METHOD=ENTER v12.
