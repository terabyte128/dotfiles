HOSTNAME=Lovelace

if [[ -z $HOSTNAME ]]; then
    echo "HOSTNAME is required"
    exit 1
fi

# set hostname
sudo scutil --set ComputerName $HOSTNAME
sudo scutil --set HostName $HOSTNAME
sudo scutil --set LocalHostName $HOSTNAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $HOSTNAME

echo "System - Disable boot sound effects."
sudo nvram SystemAudioVolume=" "

echo "System - Reveal IP address, hostname, OS version, etc. when clicking login window clock."
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

echo "System - Disable automatic termination of inactive apps."
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

echo "System - Expand save panel by default."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "System - Disable 'Are you sure you want to open this application?' dialog."
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "System - Increase window resize speed for Cocoa applications."
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo "System - Disable window resume system-wide."
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# echo "System - Disable auto-correct."
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# echo "System - Disable smart quotes (not useful when writing code)."
# defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# echo "System - Disable smart dashes (not useful when writing code)."
# defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# echo "System - Require password immediately after sleep or screen saver begins."
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "System - Avoid creating .DS_Store files on network volumes."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "System - Automatically restart if system freezes."
systemsetup -setrestartfreeze on

# echo "System - Disable software updates."
# sudo softwareupdate --schedule off

echo "Keyboard - Automatically illuminate built-in MacBook keyboard in low light."
defaults write com.apple.BezelServices kDim -bool true

echo "Keyboard - Turn off keyboard illumination when computer is not used for 5 minutes."
defaults write com.apple.BezelServices kDimTime -int 300

echo "Keyboard - Enable keyboard access for all controls."
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "Keyboard - Set a fast keyboard repeat rate."
defaults write NSGlobalDomain KeyRepeat -int 0

# echo "Keyboard - Disable press-and-hold for keys in favor of key repeat."
# defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# echo "Trackpad - Map bottom right corner to right-click."
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# echo "Trackpad - Enable tap to click for current user and the login screen."
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Trackpad - Use CONTROL (^) with scroll to zoom."
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

echo "Trackpad - Follow keyboard focus while zoomed in."
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

echo "Bluetooth - Increase sound quality for headphones/headsets."
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# echo "Menu Bar - Show only Bluetooth and Airport."
# for domain in $HOME/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
#   defaults write "${domain}" dontAutoLoad -array "/System/Library/CoreServices/Menu Extras/TimeMachine.menu"
# done

# defaults write com.apple.systemuiserver menuExtras -array \
#   "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
#   "/System/Library/CoreServices/Menu Extras/AirPort.menu"

echo "Dock - Remove all default app icons."
defaults write com.apple.dock persistent-apps -array

echo "Dock - Automatically hide and show."
defaults write com.apple.dock autohide -bool true

echo "Dock - Remove the auto-hiding delay."
defaults write com.apple.Dock autohide-delay -float 0

echo "Dock - Don’t show Dashboard as a Space."
defaults write com.apple.dock "dashboard-in-overlay" -bool true

echo "iCloud - Save to disk by default."
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "Finder - Show the $HOME/Library folder."
chflags nohidden $HOME/Library

# echo "Finder - Show hidden files."
# defaults write com.apple.finder AppleShowAllFiles -bool true

echo "Finder - Show filename extensions."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Finder - Disable the warning when changing a file extension."
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "Finder - Show path bar."
defaults write com.apple.finder ShowPathbar -bool true

echo "Finder - Show status bar."
defaults write com.apple.finder ShowStatusBar -bool true

echo "Finder - Display full POSIX path as window title."
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "Finder - Use column view in all Finder windows."
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# echo "Finder - Allow quitting via COMMAND+Q -- Doing so will also hide desktop icons."
# defaults write com.apple.finder QuitMenuItem -bool true

# echo "Finder - Disable the warning before emptying the Trash."
# defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo "Finder - Allow text selection in Quick Look."
defaults write com.apple.finder QLEnableTextSelection -bool true

# echo "iOS Simulator - Symlink the iOS Simulator application."
# sudo ln -sf "/Applications/Xcode.app/Contents/Applications/iPhone Simulator.app" "/Applications/iOS Simulator.app"

echo "Safari - Set home page to 'about:blank' for faster loading."
defaults write com.apple.Safari HomePage -string "about:blank"

echo "Safari - Hide bookmarks bar."
defaults write com.apple.Safari ShowFavoritesBar -bool false

echo "Safari - Use Contains instead of Starts With in search banners."
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo "Safari - Enable debug menu."
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo "Safari - Enable the Develop menu and the Web Inspector."
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

echo "Safari - Add a context menu item for showing the Web Inspector in web views."
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo "Safari - Disable sending search queries to Apple.."
defaults write com.apple.Safari UniversalSearchEnabled -bool false

echo "Chrome - Prevent native print dialog, use system dialog instead."
defaults write com.google.Chrome DisablePrintPreview -boolean true

echo "Mail - Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>'."
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

echo "Mail - Disable send animation."
defaults write com.apple.mail DisableSendAnimations -bool true

echo "Mail - Disable reply animation."
defaults write com.apple.mail DisableReplyAnimations -bool true

echo "Mail - Enable COMMAND+ENTER to send mail."
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" -string "@\\U21a9"

# echo "Address Book - Enable debug menu."
# defaults write com.apple.addressbook ABShowDebugMenu -bool true

# echo "iCal - Enable debug menu."
# defaults write com.apple.iCal IncludeDebugMenu -bool true

echo "TextEdit - Use plain text mode for new documents."
defaults write com.apple.TextEdit RichText -int 0

echo "TextEdit - Open and save files as UTF-8 encoding."
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

echo "Disk Utility - Enable debug menu."
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

echo "Time Machine - Prevent prompting to use new hard drives as backup volume."
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "Printer - Expand print panel by default."
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

echo "Printer - Automatically quit printer app once the print jobs complete."
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "Game Center - Disable Game Center."
defaults write com.apple.gamed Disabled -bool true

# echo "App Store - Enable the WebKit Developer Tools in the Mac App Store."
# defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# echo "App Store - Enable Debug Menu in the Mac App Store."
# defaults write com.apple.appstore ShowDebugMenu -bool true

echo "Make Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true

echo "Use current directory as default search scope in Finder"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

echo "Enable right click on trackpad"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true

echo "Mail - Show attachments as icons"
defaults write com.apple.mail DisableInlineAttachmentViewing -bool yes
