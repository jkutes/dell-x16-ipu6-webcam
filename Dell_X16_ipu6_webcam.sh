#!/bin/bash

# This script automates the installation and configuration of the Intel IPU6 camera
# on Ubuntu 24.04 by installing packages from a PPA, setting udev rules,
# and configuring a systemd service to make the camera available to applications.

set -e

echo "--- Starting Intel IPU6 Camera Installation and Configuration ---"

# --- Step 1: Add the PPA and install the required packages ---
echo "1. Adding the Intel IPU6 PPA..."
sudo add-apt-repository -y ppa:oem-solutions-group/intel-ipu6

echo "2. Updating package lists and installing core camera packages..."
sudo apt update
sudo apt install -y gstreamer1.0-icamera libcamhal-ipu6 libcamhal-ipu6-common libcamhal0 v4l-utils v4l2loopback-dkms

# --- Step 2: Set udev rules for PSYS permissions ---
echo "3. Creating udev rule for IPU6 PSYS permissions..."
echo 'KERNEL=="ipu-psys0", MODE="0660", GROUP="video"' | sudo tee /etc/udev/rules.d/99-ipu6-psys.rules > /dev/null
sudo udevadm control --reload-rules
sudo udevadm trigger

# --- Step 3: Create and enable a systemd service for the camera stream ---
echo "4. Creating systemd service file..."
sudo mkdir -p /etc/systemd/system/
sudo tee /etc/systemd/system/ipu6-camera.service > /dev/null << EOF
[Unit]
Description=Intel IPU6 Camera Service
After=network.target

[Service]
ExecStart=/bin/bash -c "gst-launch-1.0 icamerasrc ! video/x-raw,format=NV12,width=1920,height=1080 ! videoconvert ! v4l2sink device=/dev/video51"
Restart=always
User=$(whoami)
Group=video

[Install]
WantedBy=multi-user.target
EOF

echo "5. Enabling and starting the systemd service..."
sudo systemctl daemon-reload
sudo systemctl enable ipu6-camera.service
sudo systemctl start ipu6-camera.service

# --- Step 4: Load the v4l2loopback kernel module ---
echo "6. Loading v4l2loopback kernel module..."
sudo modprobe v4l2loopback

echo "--- INSTALLATION COMPLETE ---"
echo "A reboot is recommended to ensure all changes take full effect."
echo "You can check the camera with: v4l2-ctl --list-devices"
echo "or by running 'gst-launch-1.0 icamerasrc ! video/x-raw,format=NV12 ! videoconvert ! ximagesink' in a terminal."
echo "You can also verify that the 'Dynamic loading plugin' option is selected in 'Software & Updates' -> 'Additional Drivers'."

