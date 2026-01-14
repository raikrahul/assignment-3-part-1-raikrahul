# Assignment 1: Bash Scripting Basics - Original Instructions

## Overview
These are detailed instructions for how to complete Assignment 1: Bash Scripting Basics. Please follow the steps for the assignment outlined here, then submit a link to your github repository in the following peer-review assignment.

## Prerequisites & Setup
1. **Virtual Machine**: Bring up a virtual machine host environment using Virtualbox and the specific version of Ubuntu specified. **Do not** use the most recent version.
2. **GitHub Repository**: Clone the repository created from the GitHub Classroom link.
   - **CRITICAL**: This will create an empty repository. **Don’t** follow instructions to add a README commit.

## Implementation Steps

### 1. Repository Initialization
Fill with template content using the git commands below inside the repository:

```bash
git remote add assignments-base https://github.com/cu-ecen-aeld/aesd-assignments.git
git fetch assignments-base
git merge assignments-base/master
git submodule update --init --recursive
```

### 2. Development Host & Runner
- Setup your Development Host.
- Setup your Github Actions Runner (can be same machine).

### 3. Unit Tests & Configuration
1. Run `./unit-test.sh` (Expect failure).
2. Update `conf/username.txt` to include your github username.
   - **Rule**: No leading/trailing spaces, no additional lines.
3. Implement `Test_validate_username.c` in `student-test` folder.
4. Update username in `autotest-validate.c`.
5. Re-run `./unit-test.sh` (Expect success).

### 4. `finder-app/finder.sh`
**Arguments**:
1. `filesdir` (path to directory)
2. `searchstr` (text string to search)

**Requirements**:
- Exit 1 if parameters not specified.
- Exit 1 if `filesdir` does not represent a directory.
- Print: "The number of files are X and the number of matching lines are Y"
  - X: Number of files in directory and all subdirectories.
  - Y: Number of matching lines found in respective files.

**Example**:
`finder.sh /tmp/aesd/assignment1 linux`

### 5. `finder-app/writer.sh`
**Arguments**:
1. `writefile` (full path including filename)
2. `writestr` (text string to write)

**Requirements**:
- Exit 1 if arguments not specified.
- Create new file `writefile` with content `writestr`.
- **Overwrite** existing file.
- **Create path** if it doesn't exist.
- Exit 1 if file could not be created.

**Example**:
`writer.sh /tmp/aesd/assignment1/sample.txt ios`

### 6. Testing with `finder-test.sh`
Provided script that:
- Defaults: `numfiles`=10, `writestr`="AELD_IS_FUN".
- Creates `/tmp/aeld-data`.
- Loops to create files using `writer.sh`.
- Runs `finder.sh`.
- Compares output.

### 7. Full Test
- Run `full-test.sh` to prevent GitHub Actions failures.

---
**Source**: Extracted from provided instruction text.
