#!/usr/bin/env bash

INCOMING="/home/vscode/data/incoming"
PROCESSED="/home/vscode/data/processed"
LOGFILE="/home/vscode/var/log/file_processor.log"

VALID_EXTENSIONS=("csv" "log" "txt")
ERROR_PATTERN="ERROR"
WARNING_PATTERN="WARNING"

MAX_JOBS=4
RETRY_LIMIT=3
RETRY_DELAY=2

mkdir -p "$PROCESSED"
mkdir -p "$(dirname "$LOGFILE")"

log() {
    local status="$1"
    local msg="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $status: $msg" >> "$LOGFILE"
}

log "STATUS" "File processor started"

# Check for inotifywait
if command -v inotifywait >/dev/null 2>&1; then
    MODE="inotify"
    log "STATUS" "Monitoring $INCOMING (inotify mode)"
else
    MODE="polling"
    log "WARNING" "inotifywait not found, falling back to polling mode"
    log "STATUS" "Monitoring $INCOMING (polling mode)"
fi

is_valid_extension() {
    local ext="${1##*.}"
    for v in "${VALID_EXTENSIONS[@]}"; do
        [[ "$ext" == "$v" ]] && return 0
    done
    return 1
}

process_file() {
    local file="$1"
    local base="$(basename "$file")"

    # Permission check
    if [[ ! -r "$file" ]]; then
        log "ERROR" "permission denied: $base"
        return
    fi

    # Empty file check
    if [[ ! -s "$file" ]]; then
        log "ERROR" "Empty/corrupt: $base"
        return
    fi

    local attempt=1
    while (( attempt <= RETRY_LIMIT )); do
        gzip -c "$file" > "$PROCESSED/$base.gz" 2>/dev/null
        if [[ $? -eq 0 ]]; then
            mv "$file" "$INCOMING/.processed_$base" 2>/dev/null
            local orig_size=$(stat -c%s "$INCOMING/.processed_$base" 2>/dev/null)
            local gz_size=$(stat -c%s "$PROCESSED/$base.gz" 2>/dev/null)
            log "SUCCESS" "Processed $base ($orig_size→$gz_size bytes)"
            rm -f "$INCOMING/.processed_$base"
            return
        else
            log "WARNING" "Retrying failed file: $base (attempt $attempt/$RETRY_LIMIT)"
            sleep "$RETRY_DELAY"
        fi
        ((attempt++))
    done

    log "ERROR" "Failed after retries: $base"
}

monitor_inotify() {
    inotifywait -m -e close_write,create "$INCOMING" --format "%f" | while read file; do
        ext="${file##*.}"
        full="$INCOMING/$file"

        if ! is_valid_extension "$file"; then
            log "INFO" "Ignored: $file (invalid extension: .$ext)"
            continue
        fi

        # Limit parallel jobs
        while (( $(jobs | wc -l) >= MAX_JOBS )); do
            sleep 1
        done

        process_file "$full" &
    done
}

monitor_polling() {
    while true; do
        for file in "$INCOMING"/*; do
            [[ -f "$file" ]] || continue
            base="$(basename "$file")"

            if ! is_valid_extension "$base"; then
                ext="${base##*.}"
                log "INFO" "Ignored: $base (invalid extension: .$ext)"
                continue
            fi

            # Limit parallel jobs
            while (( $(jobs | wc -l) >= MAX_JOBS )); do
                sleep 1
            done

            process_file "$file" &
        done

        sleep 2
    done
}

summary_loop() {
    while true; do
        count=$(ls "$PROCESSED"/*.gz 2>/dev/null | wc -l)
        log "STATUS" "Processed: $count files (mode: $MODE)"
        sleep 10
    done
}

summary_loop &

if [[ "$MODE" == "inotify" ]]; then
    monitor_inotify
else
    monitor_polling
fi
