#!/usr/bin/env bash
# macOS system defaults
# Values captured from a configured machine (macOS 26) — re-capture with
# `defaults read <domain>` if a setting stops sticking on newer macOS.
# Run `killall` at the end to apply changes that require app restarts.

# ── Appearance ────────────────────────────────────────────────────────────────

# Dark mode (takes full effect after logout/login)
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# ── Finder ────────────────────────────────────────────────────────────────────

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Show full POSIX path in Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search This Mac by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCev"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# New Finder windows open the home folder
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show drives and removable media on the desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Snap desktop icons to grid (Desktop → right-click → Sort By → Snap to Grid).
# Nested plist keys can't be set with `defaults write`, so use PlistBuddy;
# the Add fallbacks create the keys on a fresh machine where they don't exist yet.
finder_plist="$HOME/Library/Preferences/com.apple.finder.plist"
/usr/libexec/PlistBuddy -c "Add :DesktopViewSettings dict" "$finder_plist" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :DesktopViewSettings:IconViewSettings dict" "$finder_plist" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" "$finder_plist" 2>/dev/null ||
  /usr/libexec/PlistBuddy -c "Add :DesktopViewSettings:IconViewSettings:arrangeBy string grid" "$finder_plist"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ── Dock ──────────────────────────────────────────────────────────────────────

# Keep the Dock visible (no auto-hide); delay tweaks below apply if it's ever enabled
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Don't show recent applications
defaults write com.apple.dock show-recents -bool false

# Set icon size
defaults write com.apple.dock tilesize -int 48

# Disable all hot corners (1 = no-op)
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 1
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 0

# ── Desktop & Window Management ───────────────────────────────────────────────

# Click wallpaper to show desktop: off
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -int 0

# Hide widgets on the desktop (and in Stage Manager). Don't killall
# WindowManager to apply — that ends the login session; takes effect at next login.
defaults write com.apple.WindowManager StandardHideWidgets -bool true
defaults write com.apple.WindowManager StageManagerHideWidgets -bool true

# Disable native window tiling (Rectangle handles window management)
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# ── Keyboard & Input ──────────────────────────────────────────────────────────

# Fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable auto-capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes and quotes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Globe/Fn key does nothing
defaults write com.apple.HIToolbox AppleFnUsageType -int 0

# ── Trackpad ──────────────────────────────────────────────────────────────────

# Tap to click: off
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool false
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool false

# Tracking speed: one notch below max
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5

# Click: firm
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 2
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 2

# Disable force click and haptic feedback for it
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool false
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool true
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -int 0

# Disable Look up & data detectors (three-finger tap)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0

# ── Sound ─────────────────────────────────────────────────────────────────────

# Play feedback when volume is changed
defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 1

# ── Menu Bar ──────────────────────────────────────────────────────────────────

# Show battery percentage
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

# Show Bluetooth and Sound in the menu bar
defaults -currentHost write com.apple.controlcenter Bluetooth -int 2
defaults -currentHost write com.apple.controlcenter Sound -int 18

# Clock: show day of week, hide date
defaults write com.apple.menuextra.clock ShowAMPM -bool true
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowDate -int 0

# ── Screenshots ───────────────────────────────────────────────────────────────

# Save screenshots to ~/Desktop/Screenshots
mkdir -p "$HOME/Desktop/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"

# Save as PNG
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# ── Rectangle ─────────────────────────────────────────────────────────────────
# Installed via Brewfile. Write config before first launch (or restart Rectangle
# afterwards). Accessibility permission still has to be granted manually.

# Spectacle-style shortcuts
defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -bool false
defaults write com.knollsoft.Rectangle allowAnyShortcut -bool true
defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 0
defaults write com.knollsoft.Rectangle SUEnableAutomaticChecks -bool false

# Remove top-half / bottom-half shortcuts
defaults write com.knollsoft.Rectangle topHalf -dict
defaults write com.knollsoft.Rectangle bottomHalf -dict

# Maximize: ⌘⌥↑
defaults write com.knollsoft.Rectangle maximize '<dict><key>keyCode</key><integer>126</integer><key>modifierFlags</key><integer>1572864</integer></dict>'

# ── Music ─────────────────────────────────────────────────────────────────────

# Disable song transitions (Settings → Playback → Transitions: Off).
# Applies on next Music launch; if Music is running it may overwrite this on quit.
defaults write com.apple.Music TransitionsEnabled -bool false

# ── Misc ──────────────────────────────────────────────────────────────────────

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Save to disk (not iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# ── Apply ─────────────────────────────────────────────────────────────────────

killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
killall ControlCenter 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
