Usage: Building Folder-Level Summary
You can either generate a report for all files in a folder, or simply convert a given file. Both methods are shown below.

To build a summary for all supported test runner files, simply open cmd.exe and point to the folder where the XML files are stored:

reportunit [input-folder-path]
reportunit [input-folder-path] [output-folder-path]
// all files will be created in the current folder
reportunit .

// all files will be created in the my-folder
reportunit "c:\my-folder"

// files will be created in output-folder
reportunit "c:\my-folder" "c:\output-folder
Usage: Building TestSuite-Level Summary
To build report from any NUnit TestResult XML file, point to the input file and also specify the name of the output file:

reportunit [input-file]
reportunit [input-file] [output-file]
reportunit "C:\my-folder\result.xml"
reportunit "C:\my-folder\result.xml" reportunit "C:\output-folder\report.html"
