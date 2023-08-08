import os
import subprocess
import time
import json
import requests

def restart_on_restart_string(func):
    def wrapper(*args, **kwargs):
        while True:
            result = func(*args, **kwargs)
            if isinstance(result, str) and 'https://github.com/login/device' in result:
                print("Restarting function...")
            else:
                return result
    return wrapper
  
def send_slack_message(webhook_endpoint, message):
    webhook_url = f"https://hooks.slack.com/services/{webhook_endpoint}"
    payload = {
        "text": message
    }
    headers = {'Content-type': 'application/json'}
    response = requests.post(webhook_url, json=payload, headers=headers)
    if response.status_code != 200:
        print(f"Failed to send Slack message. Status code: {response.status_code}")
    else:
        print("Slack message sent successfully.")

def uninstall_tunnel_serivce():
    print("Unstalling tunnel service...")
    uninstall_command = ["/snap/bin/code", "tunnel", "service", "uninstall"]
    subprocess.run(uninstall_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if os.path.exists("/home/kaizen/.tunnel_out"):
        os.remove("/home/kaizen/.tunnel_out")
    if os.path.exists("/home/kaizen/.tunnel_out2"):
        os.remove("/home/kaizen/.tunnel_out2")


@restart_on_restart_string
def install_tunnel_service():
    uninstall_tunnel_serivce()
    print("Installing tunnel service...")
    subprocess.Popen(
        ["/snap/bin/code", "tunnel", "service", "install", "--accept-server-license-terms", "--log", "info", "--name", "beast"],
        stdout=open(os.path.expanduser("/home/kaizen/.tunnel_out"), "w")
    )
    time.sleep(2)
    with open(os.path.expanduser("/home/kaizen/.tunnel_out"), "r") as log_file:
        install_output = log_file.read()
    return install_output

def get_installation_logs():
    print("Getting installation logs...")
    subprocess.Popen(
        ["/snap/bin/code", "tunnel", "service", "log"],
        stdout=open(os.path.expanduser("/home/kaizen/.tunnel_out2"), "w")
    )
    time.sleep(2)
    with open(os.path.expanduser("/home/kaizen/.tunnel_out2"), "r") as log_file:
        out_logs = log_file.read()
    return out_logs

def main():
    with open("/home/kaizen/.slack.json", "r") as slack_file:
        slack_config = json.load(slack_file)
        webhook_endpoint = slack_config["direct_webhook"]

    # install_output = install_tunnel_service()

    # current_date = time.strftime("%Y-%m-%d %H:%M:%S")

    # slack_message = (
    #     ":rocket: **VSCode Tunnel Service Installation Logs 1** :rocket:\n\n"
    #     f"Tunnel installation logs on: {current_date}\n\n"
    #     f"Installation logs:\n```\n{install_output}\n```\n"
    # )

    # send_slack_message(webhook_endpoint, slack_message)

    time.sleep(2)
    
    install_output = get_installation_logs()

    current_date = time.strftime("%Y-%m-%d %H:%M:%S")

    slack_message = (
        ":rocket: **Beast Mode is On** :rocket:\n\n"
        f"start time: {current_date}\n\n"
        f"code tunnel logs:\n```\n{install_output}\n```\n"
    )

    send_slack_message(webhook_endpoint, slack_message)

if __name__ == "__main__":
    main()
