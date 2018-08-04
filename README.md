# Hey you! I made an installer script to automatically setup my desktop environment! (It's install.sh)
This script will automatically install i3-gaps on any ubuntu 18.04 install. I haven't had much time to test it on other systems but if you have an issue I'll help as much as I can! I'm balancing school, work, family, friends, and coding at the moment so it might be a while until I can get back to you. Pull requests are very welcome!

## Getting Started
To easily install these configurations, clone the repo and run the ```install.sh```. If you're curious what changes it makes, follow the outline below. After it restarts, boot into ubuntu and click that little gear icon at your login screen, then click i3. That's it! There's two little changes you need to make after that if you want your desktop to look like mine (these will be automated soon!)

#### 1. Apply the system theme
   * Press ALT-D to start your app launcher, and search for lxappearance. Launch it by pressing enter, and then change the system font to arc-dark on the left. 

#### 2. Apply the system font globally
   * Open up that lxappearance again and change the font size to one larger. We just want it to create some config files. Then edit your ```~/.gtkrc-2.0``` and change ```gtk-font-name=``` to ```gtk-font-name="System San Francisco Display 10"```. That last number is your font size if you'd ike to change it. Next go to your ```~/.config/gtk-3.0``` and change the ```settings.ini``` option ```gtk-font-name=``` to ```gtk-font-name=System San Francisco Display 10```. This is an issue where lxappearance doesn't see the new font we installed. We had to chagne the system font for gtk-3 and gtk-2 because both are still used. Restart for good measure and you should be setup!

## Script Outline
If you're like me and want to know exactly what a script is changing to your computer, here's a general outline of every component and what it's changing. 

1. Configuration (Top)
   * This is where you can have exact control of what commands get executed. The script will prompt you before it installs anything besides the dependencies and i3-gaps itself anyways, but if you want to skip those prompts, this is a great place to do that!
   * The version numbers are used to download differing versions with the same curl command, from it's respective github release page
2. Update packages
   * It's always good practice to update everything before installing, so we go ahead and do that for you! This is a simple apt update and apt upgrade
3. Download dependencies
   * These are taken straight from the i3-gaps wiki for ubuntu 16.10+ (besides curl at the bottom, that one is used to download i3-gaps without opening a web browser! What a time to be alive!
4. Compiler
   * Most of this is taken straight out of the i3-gaps wiki, with a few expected customizations. It creates a ```~/build``` folder and downloads i3-gaps into that, extracts it, and compiles it. 
5. Install configs
   * This is just copying my dotfiles from my main setup. There aren't many. These include my i3 config, some install notes I use as a backup reference, screen-lock.png which is used for your screen lock, and terminator config to automatically apply the transparent background and remove the menu bars. 
   * This also copys the System San Francisco font to your .fonts directory.
6. Install i3 recommended
   * This is not a specific recommended list from i3 devs, but are some packages that I deem requirements for my configuration to work and look nice. These packages include i3blocks (menu bar) i3lock (lock screen) feh (desktop background) compton (fades between application switches) fonts-font-awesome (go-to font for icons in menu bar) fonts-fonts-hack (nice terminal font) rofi (nicer app launcher then dmenu) scrot (image manipulation for lockscreen blur effect) pavucontrol (media buttons) lxappearance (set theme and font) arc-theme (extremely nice theme)
7. Install animcogn recommended
   * Installs my recommended apps for my workspace. You may or may not like these. They are chromium-browser (google chrome but open source) terminator (terminal emulator that supports transparent background) spotify (music is pretty much required for every code session)
8. Install playerctl
   * Installs playerctl, a package that allows manipulation of what's currently playing. I modified a script off r/unixporn that blurs your lockscreen and pauses music. I found dbus to be less stable then playerctl, and opted for playerctl. An upside of playerctl is that I wrote a check to see if music is playing in the first place. This means that when you lock your screen, it pauses your music, and resumes when you unlock it. But if you weren't listening to music in the first place, it won't try to unpause anything. This is tested with spotify, though should work with alternatives like rythembox, etc, etc.
9. Download Wallpapers
   * This downloads wallpapers to your ```~/Pictures``` one named wallpaper-left.jpg and one wallpaper-right.jpg, through will work with only one monitor if you only are using one. Thanks to r/unixporn and r/wallpapers for the awesome background!
10. Reboot cycle
   * Reboots are always so boring! This one adds some spice. It shuts down your reactors, lazoors, phasors, magnetocrystaline anistrophy, etc, etc.  

## Troubleshooting

I encountered some weird issues setting up an i3-gaps desktop, with and without the script! Here's some common issues you might face and how to fix them.

#### 1. My config file is having an error! Something about a gap?
- I haven't figured out why this issue exists, but it can be easily fixed by recompiling i3-gaps. Rerun the script, and it should fix it. You can disable all the components in the top of install.sh, or just rerun it and deny all prompts (they SHOULDN'T break anything if you re-accept a prompt, but let's not test our luck! :P)

#### 2. The text for the app launcher (rofi) does not appear!
- This is an issue with the padding of rofi and the resolution of your screen! I had this issue when I ran it on my laptop as opposed to my desktop. To fix this, cut the padding in your ```~/.config/i3/scripts/rofi.sh``` in half and try from there. You can then add more padding until it looks right.
