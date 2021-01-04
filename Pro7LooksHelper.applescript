-- Using code from  https://stackoverflow.com/questions/29168474/creating-a-simple-menubar-app-using-applescript
-- thanks to https://stackoverflow.com/users/261305/markhunte

use scripting additions
use framework "Foundation"
use framework "AppKit"

property StatusItem : missing value
property newMenu : class "NSMenu"
property timer : missing value

-- Regular Timer event is used to poll the current look in Pro7 and show it in statusbar menu
on timerFired:aTimer
	tell application "System Events"
		--if (get name of every application process) contains "ProPresenter" then -- Only try to update when Pro7 is running
		if exists (processes where name is "ProPresenter") then -- Only try to update when Pro7 is running
			tell process "ProPresenter"
				StatusItem's setTitle:(name of menu item 3 of menu "Screens" of menu bar 1)
			end tell
		end if
	end tell
end timerFired:

-- Check we are running in foreground - Apparently to be thread safe and not crash
if not (current application's NSThread's isMainThread()) as boolean then
	display alert "This script must be run from the main thread." buttons {"Cancel"} as critical
	error number -128
end if

on menuNeedsUpdate:(menu)
	-- Do not update if Pro7 is not running
	tell application "System Events"
		if not (exists (processes where name is "ProPresenter")) then
			return
		end if
	end tell
	
	newMenu's removeAllItems() -- remove existing menu items
	
	tell application "System Events"
		tell process "ProPresenter"
			set LookNames to name of menu items of menu of menu item 3 of menu "Screens" of menu bar 1
		end tell
	end tell
	
	-- Add each look from Pro7 Looks menu
	set lookindex to 1
	repeat with lookName in item 1 of LookNames
		set thisMenuItem to (current application's NSMenuItem's alloc()'s initWithTitle:lookName action:"someAction:" keyEquivalent:"")
		
		(newMenu's addItem:thisMenuItem)
		(thisMenuItem's setTag:lookindex)
		(thisMenuItem's setTarget:me) -- required for enabling the menu item
		set lookindex to lookindex + 1
	end repeat
	
	newMenu's addItem:(current application's NSMenuItem's separatorItem)
	
	set thisMenuItem to (current application's NSMenuItem's alloc()'s initWithTitle:"Quit" action:"someAction:" keyEquivalent:"")
	(thisMenuItem's setTag:-1)
	(thisMenuItem's setTarget:me)
	(newMenu's addItem:thisMenuItem)
end menuNeedsUpdate:


--menuItems  action is required for the menu to be enabled
on someAction:sender
	set clickedMenuTag to (sender's tag())
	
	if clickedMenuTag = -1 then
		tell me to quit
	end if
	
	tell application "System Events"
		if (get name of every application process) contains "ProPresenter" then -- Only send menu clicks if Pro7 is running
			tell process "ProPresenter"
				click menu item (clickedMenuTag) of menu of menu item 3 of menu "Screens" of menu bar 1
			end tell
		end if
	end tell
end someAction:

-- create an NSStatusBar
on makeStatusBar()
	set bar to current application's NSStatusBar's systemStatusBar
	
	set StatusItem to bar's statusItemWithLength:-1.0
	
	-- set up the initial NSStatusBars title
	StatusItem's setTitle:"Live:"
	-- set up the initial NSMenu of the statusbar
	set newMenu to current application's NSMenu's alloc()'s initWithTitle:"Custom"
	
	newMenu's setDelegate:me (* Required delegation for when the Status bar Menu is clicked  the menu will use the delegates method (menuNeedsUpdate:(menu)) to run dynamically update.*)
	StatusItem's setMenu:newMenu
	
end makeStatusBar


my makeStatusBar()
set timer to current application's NSTimer's scheduledTimerWithTimeInterval:0.3 target:me selector:"timerFired:" userInfo:(missing value) repeats:true
