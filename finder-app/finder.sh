#!/bin/sh
# Finder Script
# Input: $1 = filesdir, $2 = searchstr
# Goal: Count files in $filesdir (recursively) and count lines matching $searchstr (recursively)

filesdir=$1
searchstr=$2

# AXIOM 1: Input variables $1 and $2 are strings or empty.
# Calculation:
# - Case A: ./finder.sh /tmp linux -> filesdir="/tmp", searchstr="linux"
# - Case B: ./finder.sh /tmp       -> filesdir="/tmp", searchstr="" (empty)
# - Case C: ./finder.sh            -> filesdir="" (empty), searchstr="" (empty)

# TASK 1: "Exits with return value 1 error and print statements if any of the parameters above were not specified"
# Check Case B or C.
# If filesdir is empty OR searchstr is empty -> FAIL.

# TODO: WRITE IF BLOCK HERE FOR PARAMETER CHECK
# Use [ -z "$var" ] to test if empty.
if [ -z "$filesdir" ] || [ -z "$searchstr" ]; then
    echo "Usage: finder.sh <filesdir> <searchstr>"
    exit 1
fi





# AXIOM 2: $filesdir must be a DIRECTORY.
# Calculation:
# - Case D: ./finder.sh /etc/passwd (file) -> Fail
# - Case E: ./finder.sh /nonexistent       -> Fail
# - Case F: ./finder.sh /tmp (directory)   -> Pass

# TASK 2: "Exits with return value 1 error and print statements if filesdir does not represent a directory on the filesystem"
# Check if $filesdir is valid directory.
# Use [ -d "$var" ] to test if directory.

# TODO: WRITE IF BLOCK HERE FOR DIRECTORY CHECK
if [ ! -d "$filesdir" ]; then
    echo "Error: $filesdir is not a directory"
    exit 1
fi



# AXIOM 3: Counting files requires recursive traversal.
# Calculation:
# - Dir: /tmp/test (contains a.txt, subdir/b.txt, subdir/c.log)
# - find /tmp/test -type f
#   -> /tmp/test/a.txt
#   -> /tmp/test/subdir/b.txt
#   -> /tmp/test/subdir/c.log
# - Output lines: 3

# TASK 3: Count the files into variable X.
# Use 'find' and 'wc -l'.

# TODO: ASSIGN VARIABLE X HERE
X=$(find "$filesdir" -type f | wc -l)



# AXIOM 4: Counting matching lines requires recursive GREP.
# Calculation:
# - File a.txt content:
#   "linux is kernel"
#   "bsd is kernel"
# - File b.txt content:
#   "linux mint"
# - Command: grep -r "linux" /tmp/test
#   -> /tmp/test/a.txt:linux is kernel
#   -> /tmp/test/b.txt:linux mint
# - Output lines: 2

# TASK 4: Count the matching lines into variable Y.
# Use 'grep -r' and 'wc -l'.

# TODO: ASSIGN VARIABLE Y HERE
Y=$(grep -r "$searchstr" "$filesdir" | wc -l)



# TASK 5: Print the result.
# Format: "The number of files are X and the number of matching lines are Y"

# TODO: WRITE ECHO STATEMENT HERE
echo "The number of files are $X and the number of matching lines are $Y"

