# Assignment 1 Analysis & Planning Worksheet

## 1. Environment & Setup Traps
* **Ubuntu Version**: "Don't use the most recent version".
    * *Risk*: Newer tools/compilers might break course scripts.
    * *Action*: Check course resources exactly for the required version (likely 20.04 or 22.04 LTS, not standard latest).
* **VirtualBox**: VM must support nested virtualization if running Docker inside.

## 2. Git Repository Traps
* **The "Empty Repo" Trap**:
    * *Instruction*: "Don’t follow the instructions... to add a README commit."
    * *Why?* If you commit a README, `git merge assignments-base/master` will refuse to merge unrelated histories.
    * *Critical*: Must run git commands on a truly empty (or cloned-empty) repo.
* **Submodule Trap**:
    * *Instruction*: `git submodule update --init --recursive`
    * *Why?* `aesd-assignments` (base) contains `assignment-autotest` as a submodule.
    * *Failure Mode*: If forgotten, `unit-test.sh` file checks will fail weirdly.

## 3. Configuration Parsers Traps
* **username.txt**:
    * *Instruction*: "no leading/trailing spaces, no additional lines"
    * *Why?* The C test `Test_validate_username.c` likely uses `strcmp` or basic reading without trimming.
    * *Edge Case*: `echo "user " > conf/username.txt` = FAIL. `echo "user\n" > conf/username.txt` = FAIL.
    * *Requirement*: Exact byte match.

## 4. `finder.sh` - "The Searcher" Drill Down
* **Inputs**: `filesdir` ($1), `searchstr` ($2).
* **Validation 1 (Parameter Existence)**:
    * *Condition*: Are $1 AND $2 present?
    * *Trap*: distinct error message?
    * *Exit*: 1.
* **Validation 2 (Directory Existence)**:
    * *Condition*: Does `$filesdir` exist AND is it a directory?
    * *Command*: `[ -d "$filesdir" ]`
    * *Exit*: 1.
* **Logic (The Core Challenge)**:
    * *Fact X (File Count)*: "files in directory and all subdirectories".
        * *Tool*: `find`.
        * *Edge Case*: Do directories count as files? Usually "number of files" implies leaf nodes (`-type f`).
        * *Edge Case*: Hidden files?
    * *Fact Y (Matching Lines)*: "number of matching lines".
        * *Tool*: `grep -r`.
        * *Distinction*: Matching *lines* vs matching *instances* vs matching *files*.
        * *Requirement*: "matching line refers to a line which contains searchstr".
        * *Command*: `grep -r "searchstr" "dir" | wc -l` ?
* **Output Format**: Exact string matching required by `finder-test.sh`.

## 5. `writer.sh` - "The Creator" Drill Down
* **Inputs**: `writefile` ($1 - full path), `writestr` ($2).
* **Validation**:
    * *Condition*: Are $1 AND $2 present?
    * *Exit*: 1.
* **Logic (The Path Problem)**:
    * *Requirement*: "creating the path if it doesn’t exist".
    * *Input Example*: `/tmp/aesd/assignment1/sample.txt`
    * *Problem*: `/tmp/aesd/assignment1` might not exist.
    * *Solution*: Extract directory from path (`dirname`). Create directory (`mkdir -p`).
* **Logic (The Write Problem)**:
    * *Requirement*: "Overwrite any existing file".
    * *Tool*: `echo "str" > "file"`.
* **Error Handling**:
    * *Requirement*: "Exit 1... if the file could not be created".
    * *Scenario*: Permissions error? Disk full?
    * *Check*: Check exit status of write command.

## 6. Testing Hierarchy
1.  **Unit Test (`unit-test.sh`)**:
    *   Tests C code (`Test_validate_username.c`).
    *   Validates environment/repo setup.
2.  **Finder Test (`finder-test.sh`)**:
    *   Integration test.
    *   Generates files using YOUR `writer.sh`.
    *   Counts using YOUR `finder.sh`.
    *   *Self-Correction*: If `finder-test.sh` fails, is it the writer or the finder?
3.  **Full Test (`full-test.sh`)**:
    *   The "Final Exam" before push.

## 7. Submission Checklist
*   [ ] Did I create a `student-test` directory? (No, `student-test/Test_validate_username.c` exists, I edit it).
*   [ ] Is `conf/username.txt` clean?
*   [ ] Does `writer.sh` handle deep non-existent paths?
*   [ ] Does `finder.sh` recursively count files (not dirs)?
*   [ ] Did I run `full-test.sh`?

## 8. Definition of Done
*   GitHub Actions: Green Check.
*   Rubric Alignment:
    *   Repo created correctly?
    *   `finder.sh` error handling?
    *   `writer.sh` file creation?
    *   Git commit history (not just one big commit)?
