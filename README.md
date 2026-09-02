# Assignment: Shell Automation for File Processing

## Introduction

In this assignment, you will build a Bash script that continuously monitors a specific directory, processes supported files in parallel, handles various error cases, and logs all activity in a structured and traceable way.

This exercise helps you practice Unix automation workflows commonly used in system administration, data pipelines, and DevOps environments.

---

## Learning Outcomes

By completing this assignment, you will strengthen your ability to:

- Use file monitoring tools (`inotifywait`, `find`) in shell scripts.
- Apply parallel file processing with `gzip` and background jobs.
- Handle common errors (file access, empty/corrupt files).
- Create structured log output with timestamps and status messages.
- Develop robust Bash scripts ready for production use or grading automation.

---------

## **Working with Dev Container**

To complete this assignment in a reliable and fully configured environment, please refer to the instructions in the file: **`README-devcontainer.md`**. This guide walks you through opening the assignment in **Visual Studio Code** using a **Dev Container**, which automatically installs all necessary Python libraries and tools. Following that setup ensures that the notebook runs smoothly without manual configuration or missing dependencies. Make sure to open the **main assignment folder** in VS Code and follow the steps outlined in the Dev Container guide before starting the notebook.

-----------

## Your Task

You must implement a Bash script called `file_processor.sh` that satisfies the functional and technical requirements described below.  

**This is the only file you need to write.**

Your script will be automatically tested using an internal autograder.  You will not see or interact with the test scripts or grading configuration.

> Do not add or modify any other files.  
> 
> The autograder will run your script in a controlled environment and evaluate its behavior based on log output and file operations.

---

## Instructions

You are required to implement a script called `file_processor.sh` with the following functionality:

### 1. Directory Monitoring

- Monitor the folder:  `/home/vscode/data/incoming`

- Only respond to new or updated files with these extensions:
  
  - `.csv`, `.log`, `.txt`

- Ignore any other file types (e.g., `.exe`, `.tmp`, `.json`)

- Use `inotifywait` for real-time file watching. If unavailable, fallback to a polling mechanism.

---

### 2. File Processing

- Each valid file must be:
  - **Compressed using `gzip`**
  - **Moved** to: `/home/vscode/data/processed`
- Processing should happen **in parallel** (e.g., background jobs) while limiting concurrent work to avoid system overload.

---

### 3. Error Handling

- Your script must:
  
  - **Skip unreadable files** (e.g., permission denied)
  
  - **Detect and log empty/corrupt files**
  
  - **Retry up to 3 times** for transient errors, with a delay between retries
  
  - **Use hardcoded default patterns** if pattern matching is needed:

```bash
ERROR_PATTERN="ERROR"
WARNING_PATTERN="WARNING"
```

> You should **not use or require any external config file** like `patterns.conf`. This makes your script grading-compatible and portable.

### 4. Logging System

- All actions must be logged to this file: `/home/vscode/var/log/file_processor.log`

- Each log line must follow this format:

```ruby
[YYYY-MM-DD HH:MM:SS] STATUS: Message
```

- Use these `STATUS` labels:

| STATUS    | Description                                              |
| --------- | -------------------------------------------------------- |
| `SUCCESS` | File processed and compressed successfully               |
| `ERROR`   | File could not be read, was empty, or failed compression |
| `WARNING` | Retry messages or fallback conditions                    |
| `INFO`    | Files ignored due to invalid type                        |
| `STATUS`  | System messages (startup, monitoring method, progress)   |

---

### 5. System Monitoring

Your script must periodically log processing summaries, including:

- Total number of `.gz` files in the processed folder

- Current mode (inotify or polling)

---

### 6. File System Changes

Your script must demonstrate proper file handling by moving and compressing files correctly. The folder contents should change as follows:

#### **Before Processing:**

```plaintext
/home/vscode/data/incoming/
├── sales.csv
├── system.log
├── notes.txt
├── archive.tmp       # Should be ignored
├── secret.csv        # May cause permission error
├── empty.log         # Should trigger empty file error
```

#### **After Processing:**

```plaintext
/home/vscode/data/processed/
├── sales.csv.gz
├── system.log.gz
├── notes.txt.gz
```

#### **Log File Output (Example):**

```log
 [2025-06-01 10:00:00] STATUS: File processor started
[2025-06-01 10:00:01] STATUS: Monitoring /home/vscode/data/incoming (inotify mode)
[2025-06-01 10:00:02] SUCCESS: Processed sales.csv (4100→930 bytes, 1s)
[2025-06-01 10:00:03] SUCCESS: Processed system.log (5250→1020 bytes, 2s)
[2025-06-01 10:00:04] SUCCESS: Processed notes.txt (1780→490 bytes, 1s)
[2025-06-01 10:00:05] INFO: Ignored: archive.tmp (invalid extension: .tmp)
[2025-06-01 10:00:06] ERROR: permission denied: secret.csv
[2025-06-01 10:00:07] ERROR: Empty/corrupt: empty.log
[2025-06-01 10:00:08] WARNING: Retrying failed file: unstable_data.csv (attempt 1/3)
[2025-06-01 10:00:10] SUCCESS: Processed unstable_data.csv (3900→950 bytes, 2s)
[2025-06-01 10:00:15] STATUS: Processed: 4 files
```

----

## Testing the Script

You can test your implementation using the provided script:

```bash
./test_file_processor.sh
```

#### It will simulate:

- Valid files (`.csv`, `.log`, `.txt`)

- Empty file

- Permission-restricted file

- Ignored file types (`.tmp`, etc.)

#### It will automatically verify if:

- Compressed files exist

- Log contains `SUCCESS`, `ERROR`, and `INFO`

- Script handles cleanup

## Deliverables

You must submit the following files:

1. `file_processor.sh` – your main Bash script

2. Any notes or helper files (if needed)

---

## Submission & Grading

- Only your `file_processor.sh` will be graded.
- This assignment uses an **automated grader** that will test your script using several file-processing scenarios.
- You will **not** be given access to the test scripts or grader.
- Make sure your script:
  - Handles all edge cases
  - Follows the logging format exactly
  - Does not rely on external configuration
- Commit and push your work when ready.

---

## Conclusion

This assignment prepares you for real-world Unix scripting by combining event-driven monitoring, parallel processing, and robust error handling. By implementing clear logging and retry mechanisms, your solution will be both human-readable and machine-testable, making it ready for automated grading and real-time use in system pipelines.
