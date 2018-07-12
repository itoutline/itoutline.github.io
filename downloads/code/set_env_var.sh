#!/usr/bin/env bash

sudo -v

cat << EOF | sudo tee /etc/environment > /dev/null
#!/bin/sh

set -e

syslog -s -l warn "Set environment variables with /etc/environment $(whoami) - start"


### Set your variable here:
#launchctl setenv JAVA_HOME      /usr/local/jdk1.7
launchctl setenv MAVEN_HOME     /opt/local/share/java/maven3
launchctl setenv STUDIO_JDK     /Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk
############################

if [ -x /usr/libexec/path_helper ]; then
        export PATH=""
            eval `/usr/libexec/path_helper -s`
                launchctl setenv PATH $PATH
            fi

            osascript -e 'tell app "Dock" to quit'

            syslog -s -l warn "Set environment variables with /etc/environment $(whoami) - complete"
EOF

cat << EOF | sudo tee /Library/LaunchAgents/environment.user.plist > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>environment.user</string>
    <key>ProgramArguments</key>
    <array>
            <string>/etc/environment</string>
    </array>
    <key>KeepAlive</key>
    <false/>
    <key>RunAtLoad</key>
    <true/>
    <key>WatchPaths</key>
    <array>
        <string>/etc/environment</string>
    </array>
</dict>
</plist>
EOF

cat << EOF | sudo tee /Library/LaunchDaemons/environment.plist > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>environment</string>
    <key>ProgramArguments</key>
    <array>
            <string>/etc/environment</string>
    </array>
    <key>KeepAlive</key>
    <false/>
    <key>RunAtLoad</key>
    <true/>
    <key>WatchPaths</key>
    <array>
        <string>/etc/environment</string>
    </array>
</dict>
</plist>
EOF

sudo chmod 555 /etc/environment
sudo chmod 600 /Library/LaunchAgents/environment.user.plist /Library/LaunchDaemons/environment.plist
sudo chown root:wheel /etc/environment /Library/LaunchAgents/environment.user.plist /Library/LaunchDaemons/environment.plist

launchctl load -w /Library/LaunchAgents/environment.user.plist
sudo launchctl load -w /Library/LaunchDaemons/environment.plist

