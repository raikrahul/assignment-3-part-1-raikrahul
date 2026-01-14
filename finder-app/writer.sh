#!/bin/sh
# Writer Script
# Input: $1 = writefile (full path), $2 = writestr (content)
# Goal: Create file at $writefile containing $writestr, ensuring parent dirs exist.

writefile=$1
writestr=$2

# AXIOM 1: Input Check
# Calculation:
# - Case A: ./writer.sh /tmp/a.txt hello -> writefile="/tmp/a.txt", writestr="hello" -> OK
# - Case B: ./writer.sh /tmp/a.txt       -> writefile="/tmp/a.txt", writestr=""    -> FAIL (requires 2 args?)
#   Wait, instruction says "if any of the arguments... were not specified".
#   Bash: $2 is null if not provided.
# - Case C: ./writer.sh                  -> writefile="", writestr=""              -> FAIL

# TASK 1: Check if writefile OR writestr is empty string.
# Exit 1 if true.

# TODO: WRITE PARAMETER CHECK
if [ -z "$writefile" ] || [ -z "$writestr" ]; then
    echo "Usage: writer.sh <writefile> <writestr>"
    exit 1
fi



# AXIOM 2: The Path Problem (The Trick)
# Calculation:
# - Input: /tmp/aesd/assignment1/sample.txt
# - Filesystem state: /tmp/aesd exists. /tmp/aesd/assignment1 DOES NOT EXIST.
# - Command: echo "ios" > /tmp/aesd/assignment1/sample.txt
#   -> Error: "No such file or directory" (because parent dir is missing).
# - Need: mkdir -p /tmp/aesd/assignment1

# TASK 2: Extract the directory path from $writefile.
# Tool: 'dirname' command.
# Example: dirname /a/b/c.txt -> /a/b

# TODO: EXTRACT DIRNAME INTO VARIABLE 'writedir'
writedir=$(dirname "$writefile")


# TASK 3: Create the directory path.
# Tool: 'mkdir -p' (flag -p creates parents and doesn't complain if exists).

# TODO: CREATE DIRECTORY
mkdir -p "$writedir"



# AXIOM 3: Writing the file & Error Handling
# Calculation:
# - Command: echo "content" > "file"
# - Return code: $?
# - Case Success: Disk has space, permission defined. $? = 0.
# - Case Fail: Read-only FS, Permission denied. $? != 0.

# TASK 4: Write content to file AND check for failure.
# "Exits with value 1 ... if the file could not be created."

# TODO: WRITE FILE AND CHECK EXIT STATUS
if ! echo "$writestr" > "$writefile"; then
    echo "Error: Could not write to file $writefile"
    exit 1
fi


