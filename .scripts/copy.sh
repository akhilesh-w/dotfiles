
#!bin/zsh

# Function to send Dunst notification
send_notification() {
    dunstify "Clipboard Content Copied" "$1"
}

# Monitor clipboard for changes
while true; do
    # Get current clipboard content
    clipboard=$(xclip -selection clipboard -o)

    # Check if clipboard content has changed
    if [[ "$clipboard" != "$prev_clipboard" ]]; then
        # Send notification with clipboard content
        send_notification "$clipboard"

        # Update previous clipboard content
        prev_clipboard="$clipboard"
    fi

    # Check clipboard every 1 second
    sleep 1
done
