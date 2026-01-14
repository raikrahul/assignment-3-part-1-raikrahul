# ERROR REPORT: Assignment 1 - Linux System Programming

## Session Date: 2026-01-14

---

## ERROR 1: SUBMODULE VERSION MISMATCH

### Symptom
```
error: implicit declaration of function 'memmove' [-Werror=implicit-function-declaration]
error: implicit declaration of function 'strlen' [-Werror=implicit-function-declaration]
```

### Root Cause
- `git submodule update --init --recursive` cloned `assignment-autotest` at commit `83e5dfa`.
- Commit `83e5dfa` contains file `username-from-conf-file.h` WITHOUT `#include <string.h>`.
- Upstream fixed this in commit `4d05932` but `aesd-assignments/master` still pins `83e5dfa`.

### Documentation Not Verified
- Did NOT verify submodule commit hash after clone.
- Did NOT compare local `username-from-conf-file.h` against upstream `master`.
- Did NOT run `git log` inside `assignment-autotest/` to check version.

### Time Wasted
- 4 failed `unit-test.sh` runs.
- 5 incorrect edits to `Test_validate_username.c` attempting to fix include order.
- ~8 minutes.

---

## ERROR 2: INCORRECT ASSUMPTION ABOUT INCLUDE ORDER FIX

### Symptom
Multiple attempts to reorder `#include` statements in `Test_validate_username.c`.

### Incorrect Actions Taken
1. Added `#include <string.h>` to `Test_validate_username.c`.
2. Attempted to move `<string.h>` before `username-from-conf-file.h`.
3. Repeated edits with incorrect `replace_file_content` target matching.

### Correct Action (Not Taken Initially)
- Update the submodule: `cd assignment-autotest && git checkout origin/master`.

### Documentation Not Read
- Course wiki page: "Setting Up Your Development Host" may contain submodule update procedures.
- Did NOT inspect `assignment-autotest/.git` to understand it was a separate repository.

### Verbatim Error Output Ignored Initially
```
/home/r/Desktop/linux-sysprog-buildroot/module1/student-test/assignment1/../../assignment-autotest/test/assignment1/username-from-conf-file.h:4:1: note: include '<string.h>' or provide a declaration of 'memmove'
    3 | #include <ctype.h>
  +++ |+#include <string.h>
    4 |
```
- The error message specifically says the problem is in `username-from-conf-file.h` (line 4), not in `Test_validate_username.c`.
- Misread the error: attempted to fix the wrong file.

---

## ERROR 3: ACTIONS RUNNER TOKEN SENSITIVITY

### Fact
- GitHub Actions runner tokens expire in ~1 hour.
- Token provided: `AAJJLW7YGUWKFIYWVZQGS4TJM4WW6`.

### Risk Not Communicated
- If token had expired during download (212MB @ ~2MB/s = ~2min), configuration would have failed.
- No fallback plan documented.

### Documentation Not Read
- GitHub Actions documentation: "Tokens expire after 1 hour of generation."

---

## ERROR 4: FILE EDIT TOOL MISUSE

### Symptom
```
You had inaccuracies in your replacement chunks, so you should review the file contents before making further edits.
```

### Incorrect Actions
1. `replace_file_content` called with `TargetContent` that did not exactly match file contents.
2. Multiple edits to same file in sequence without verifying intermediate state.
3. Assumed file state instead of reading file before edit.

### Correct Procedure (Not Followed)
1. `view_file` → Read exact content.
2. `replace_file_content` → Match exactly.
3. `view_file` → Verify.

### Time Wasted
- 3 failed edit attempts.
- ~3 minutes.

---

## ERROR 5: DID NOT VERIFY ORIGINAL FILE BEFORE MODIFYING

### Fact
- Original `Test_validate_username.c` from upstream:
```c
#include "unity.h"
#include <stdbool.h>
#include <stdlib.h>
#include "../../examples/autotest-validate/autotest-validate.h"
#include "../../assignment-autotest/test/assignment1/username-from-conf-file.h"
```

### Modification Made Without Verification
- Added `#include <string.h>` which was NOT in original.
- Reordered includes which were NOT reordered in original.

### Documentation Not Consulted
- Did NOT fetch `https://raw.githubusercontent.com/cu-ecen-aeld/aesd-assignments/master/student-test/assignment1/Test_validate_username.c` BEFORE editing.
- Did NOT compare local file to upstream BEFORE editing.

---

## ERROR 6: SUBMODULE CONCEPT NOT UNDERSTOOD BEFORE EXECUTION

### Instruction Given
```
git submodule update --init --recursive
```

### Understanding At Time of Execution
- "This clones some test files."

### Correct Understanding (Discovered Later)
- A submodule is a pointer to a specific commit in another repository.
- `--recursive` clones nested submodules.
- The pinned commit may be outdated.
- Updates to the submodule repo do NOT automatically update the pin.

### Documentation Not Read Before Execution
- `man git-submodule`
- `git help submodule`
- Course wiki explanation of submodules (if any).

---

## ERROR 7: BUILD DIRECTORY NOT CLEANED

### Symptom
- Repeated `unit-test.sh` failures even after source changes.

### Root Cause
- CMake caches build artifacts in `/build/`.
- Stale object files from previous failed builds.

### Correct Action (Taken Eventually)
```bash
rm -rf build && ./unit-test.sh
```

### Documentation Not Read
- CMake documentation: "Clean builds require deleting `CMakeCache.txt` or build directory."

---

## ERROR 8: DID NOT READ VERBATIM ERROR MESSAGE PATHS

### Verbatim Error
```
/home/r/Desktop/linux-sysprog-buildroot/module1/student-test/assignment1/../../assignment-autotest/test/assignment1/username-from-conf-file.h:33:13: error
```

### Path Decomposition Not Performed
```
student-test/assignment1/
  ../../                    → Go up 2 directories → module1/
  assignment-autotest/      → Submodule directory
  test/assignment1/         → Test files
  username-from-conf-file.h → THE ACTUAL BROKEN FILE
```

### Misinterpretation
- Assumed error was in `Test_validate_username.c`.
- Did NOT realize error was in included header from submodule.

---

## ERROR 9: DID NOT QUESTION WHY ORIGINAL WORKS

### Question Not Asked
- "If the original `Test_validate_username.c` does NOT have `#include <string.h>`, why does it work for other students?"

### Answer (Discovered Later)
- Other students have updated submodules.
- The upstream `username-from-conf-file.h` includes `<string.h>`.
- Our local submodule was outdated.

### Thought Process Missing
- Compare working (upstream) vs broken (local).
- Diff the files.

---

## SUMMARY STATISTICS

| Metric | Value |
|--------|-------|
| Total Errors | 9 |
| Errors Due to Not Reading Documentation | 4 |
| Errors Due to Misreading Error Messages | 3 |
| Errors Due to Incorrect Tool Usage | 2 |
| Total Time Wasted | ~15 minutes |
| Failed Commands | 5 |
| Incorrect File Edits | 6 |

---

## LESSONS

1. Read error message paths completely. The path tells you which file is broken.
2. Compare local files to upstream before assuming local is correct.
3. Submodules are snapshots. They can be outdated.
4. Clean build directory after source changes.
5. Verify file state before and after edits.
