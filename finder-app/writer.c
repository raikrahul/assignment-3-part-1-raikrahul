#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>

/**
 * writer.c
 *
 * Writes a string to a file specified by arguments.
 * Uses syslog for logging status and errors.
 *
 * Usage: ./writer <file> <string>
 */

int main(int argc, char *argv[]) {
  // Setup syslog logging
  openlog("writer", LOG_PID | LOG_CONS, LOG_USER);

  // Check arguments
  // Expect 3 arguments: program name, file path, string to write
  if (argc != 3) {
    syslog(LOG_ERR, "Invalid arguments: Expected 2 arguments, got %d",
           argc - 1);
    fprintf(stderr, "Error: Invalid arguments. Usage: %s <file> <string>\n",
            argv[0]);
    closelog();
    return 1;
  }

  const char *filepath = argv[1];
  const char *writestr = argv[2];

  syslog(LOG_DEBUG, "Writing %s to %s", writestr, filepath);

  // Open file for writing
  FILE *f = fopen(filepath, "w");
  if (f == NULL) {
    // Log error with errno description
    syslog(LOG_ERR, "Failed to open file %s: %s", filepath, strerror(errno));
    perror("Error opening file");
    closelog();
    return 1;
  }

  // Write string to file
  if (fprintf(f, "%s", writestr) < 0) {
    syslog(LOG_ERR, "Failed to write to file %s: %s", filepath,
           strerror(errno));
    perror("Error writing to file");
    fclose(f);
    closelog();
    return 1;
  }

  // Clean up
  fclose(f);
  closelog();

  return 0;
}
