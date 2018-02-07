*** Code execution instructions: ****

-- Extract 'Git' folder, which contains two folders namely 'common' & 'fleet-management-data-processing-and-analysis',
   save it in your destination 
-- make sure the files from the above two folders are readable (check permission for read/write -- optional)
-- Intall python 3.5 & intall Pymongo library which is a connector to the MongoDB
-- Check if Pymongo is installed by entering 'import Pymongo' in your python interpreter. If installed 'no error messages'
-- open 'xml_parsing.py' in your favourite text editor (Notepad++ for example)
-- Line 21: Edit the date parameters set to the desired date (MM-DD-YY format) {pd.date_range('xx/xx/xxxx', 'xx/xx/xxxx')} and save the file
-- open your command line (Cygwin for Windows or Terminal for Linux as well) and naviate to the folder 'fleet-management-data-processing-and-analysis'
-- Enter 'python xml_parsing.py' (without quotes)
-- while running, the code will print the following messages.. 

*****************************************************
[<your date parameters>]
### (count of records extracted for <asset name>)
<asset name>
### (count of records extracted for <asset name>) 
<asset name>
*****************************************************

-- once the code is run successfully, the resultant files namely 'sample_file' & 'file-for-app' will be created under 'fleet-management-data-processing-and-analysis' folder. 
-- The 'sample_file' will be given as an input to Tableau Dashboard. 
-- The 'file-for-app' will be used in RShiny application which is for 'Cluster analysis for Anamoly detection' 

**** Thank you ****
