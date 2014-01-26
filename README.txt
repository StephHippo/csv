Handling Erroneous User Input
Assumed that Spring and Fall abbreviations may have variations and accounted for some common errors
Mapped common errors to the correct F or S format  and alerts user in the log that the program made changes

Assumed that names may contain illegal characters
Removes illegal characters and alerts user in the log that the program made changes

Assumed that ids should go unchanged to ensure users stay unique
If an id length was anything but 7 characters, log the error message and do not convert to CSV

Decisions on local and global error handling
Anything that could be sanitized was handled locally within routines
A status variable notified the rest of the program

Error propagation through the code
The status variable prevents error propagation from reaching the entry toCSV

Presence and Location of a barricade
EntryValidator is the barricade. It only passes data to the entry class if valid.