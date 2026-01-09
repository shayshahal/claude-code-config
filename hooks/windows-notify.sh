#!/bin/bash
# Windows + Phone notification from WSL2 when Claude needs input

# Read notification JSON from stdin
INPUT=$(cat)

# Log for debugging
echo "$(date): $INPUT" >> /tmp/claude-notify-debug.log

# Extract fields using grep/sed (no jq dependency)
MESSAGE=$(echo "$INPUT" | grep -o '"message":"[^"]*"' | sed 's/"message":"//;s/"$//')
TYPE=$(echo "$INPUT" | grep -o '"notification_type":"[^"]*"' | sed 's/"notification_type":"//;s/"$//')

# Fallbacks
[ -z "$MESSAGE" ] && MESSAGE="Claude Code needs your attention"
[ -z "$TYPE" ] && TYPE="notification"

# Set title based on type
case "$TYPE" in
  permission_prompt)
    TITLE="Permission Required"
    PRIORITY="high"
    ;;
  idle_prompt)
    TITLE="Waiting for Input"
    PRIORITY="default"
    ;;
  *)
    TITLE="Claude Code"
    PRIORITY="default"
    ;;
esac

# Encode message as base64 for safe PowerShell transfer
MSG_B64=$(echo -n "$MESSAGE" | base64 -w0)

# Windows toast notification using base64 decode
powershell.exe -Command "
\$msgBytes = [System.Convert]::FromBase64String('$MSG_B64')
\$msg = [System.Text.Encoding]::UTF8.GetString(\$msgBytes)
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > \$null
\$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
\$textNodes = \$template.GetElementsByTagName('text')
\$textNodes.Item(0).AppendChild(\$template.CreateTextNode('$TITLE')) > \$null
\$textNodes.Item(1).AppendChild(\$template.CreateTextNode(\$msg)) > \$null
\$toast = [Windows.UI.Notifications.ToastNotification]::new(\$template)
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Claude Code').Show(\$toast)
" 2>/dev/null &

# Phone notification via ntfy.sh
NTFY_TOPIC="shay-claude-code"
curl -s \
  -H "Title: $TITLE" \
  -H "Priority: $PRIORITY" \
  -H "Tags: robot" \
  -d "$MESSAGE" \
  "https://ntfy.sh/$NTFY_TOPIC" 2>/dev/null &

wait
exit 0
