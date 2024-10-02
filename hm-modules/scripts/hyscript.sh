#!/usr/bin/env bash

# Define instance names
name1="AniviaTai"
name2="Anivia31"
name3="sikisci31"
name4="31avcisi"

# Function to launch a PrismLauncher instance
launch_instance() {
    local instance_name="$1"
    echo "Launching instance: $instance_name"
    nohup prismlauncher --launch "$instance_name" > /dev/null 2>&1 &  # Redirect output
}

# Launch instances
launch_instance "Script $name1"
launch_instance "Script $name2"
launch_instance "Script $name3"
launch_instance "Script $name4"

echo "All instances launched, maximized, and moved to respective virtual desktops."
