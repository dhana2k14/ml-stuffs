* Connect to SQL SERVER Table with WHERE Clause.

GET DATA  /TYPE=ODBC  /CONNECT='DSN=AG;UID=;Trusted_Connection=Yes;APP=IBM SPSS Products: Statistics '+
    'Common;WSID=DHANASEKARANP;DATABASE=AG;LANGUAGE=us_english'  /SQL='SELECT Pin,PrevTot FROM '+
    'AG.dbo.[CojAgRecAll009Jan13] where Rec=''Head'''  /ASSUMEDSTRWIDTH=255.
CACHE.
EXECUTE.



