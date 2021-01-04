# Pro7LooksHelper-AppleScript
An AppleScript "App" that adds a Pro7 Looks-Menu to your MacOS menu-bar, so you can can always see the current look (and quickly choose a new look).

This is a working "proof of concept". I probably "should have" used a different technology like Electron or even a native app in XCode - but I wanted something quick and fast, as I live in hope that RV will add topmost display of current look as a new feature in Pro7 itself one day soon-ish.

![Screenshot](Pro7LooksHelper%20Menu%20Demo.jpg)


1. Open Apple "Script Editor"
2. Make a new empty script.
3. Paste code from Pro7LooksHelper.applescript (or download and open in Apple Script Editor)
4. Save as "Pro7LooksHelper.app" using File Format: **Application** and with **Stay open after run handler** option checked. *(You can name it what ever you like)*
5. You now have an App that is almost ready to run and use! But first, you need to allow this new app to control your computer in security settings by following the next two steps.
6. Right-click (or CTRL and left click) the application to get the pop-up menu and select Open from that menu.
7. Follow prompts to allow your new app, "Pro7LooksHelper.app", to control your computer. *You can manage the list of apps that can control your computer in System Preferences -> Security & Privacy -> Privacy -> Accessibility*
8. After above steps, you can double-click to open the application normally anytime in the future.
