#!/bin/bash

# Function to send Slack message
send_slack_message() {
    local webhook_endpoint=$1
    local message=$2

    local webhook_url="https://hooks.slack.com/services/${webhook_endpoint}"
    curl -X POST -H 'Content-type: application/json' --data '{
        "text": "'"$message"'"
    }' "$webhook_url"
}

# Read Slack webhook endpoint from .slack.json file
webhook_endpoint=$(jq -r '.direct_webhook' .slack.json)

# Start VSCode tunnel service
uninstall() {
    echo 'uninstalling'
    code tunnel service uninstall
    rm ~/.tunnel_out
    rm ~/.tunnel_out2
}

install() {
    # Run the installation command in the background and capture output to a file
    echo 'installing'
    code tunnel service install --accept-server-license-terms --log info --name beast > ~/.tunnel_out &
}

get_logs() {
    echo 'getting logs'
    code tunnel service log > ~/.tunnel_out2 &
}

uninstall

# Wait for 1 second to allow some logs to accumulate
sleep 2

install

# Wait for 1 second to allow some logs to accumulate
sleep 2

# Read the captured output from the file
install_output=$(cat ~/.tunnel_out)

current_date=$(date)

echo $install_output

# Construct the Slack message
slack_message=":rocket: **VSCode Tunnel Service Installation Logs 1** :rocket:\n\n"
slack_message+="Tunnel installation logs on: $current_date\n\n"
slack_message+="Installation logs:\n\`\`\`\n${install_output}\n\`\`\`"

# Send Slack message
send_slack_message "$webhook_endpoint" "$slack_message"

# Main script

# Get current date and time
current_date=$(date)

# # Wait for a few seconds for VSCode to start
# sleep 2

# current_date=$(date)
# # Get VSCode tunnel service logs
# get_logs
# log_message="$(cat ~/.tunnel_out2)"
# echo $log_message

# # Construct the Slack message
# slack_message=":rocket: **VSCode Tunnel Service Logs 2** :rocket:\n\n"
# slack_message+="Tunnel installation logs on: $current_date\n\n"
# slack_message+="Logs:\n\`\`\`\n${log_message}\n\`\`\`"

# # # Send Slack message
# send_slack_message "$webhook_endpoint" "$slack_message"
