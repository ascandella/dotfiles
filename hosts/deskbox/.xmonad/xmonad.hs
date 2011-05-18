import XMonad hiding (Tall)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import XMonad.Util.Loggers
import XMonad.Util.EZConfig      (additionalKeysP)
import System.IO

--main = xmonad =<< xmobar myConfig
-- myConfig = defaultConfig {
main = do
    statuspipe <- spawnPipe "dzen2 -bg black -fg white -ta l -w 1680"
    spawn "conky -d"
    spawn myScreensaver
--    bar <- spawnPipe myDateBar
    xmonad $ defaultConfig {
        modMask = mod4Mask
        , terminal = myTerminal
        , borderWidth = 2
        , focusedBorderColor = myFocusedBorderColor
        , normalBorderColor  = myNormalBorderColor
        , startupHook = myStartupHook
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , manageHook = manageDocks <+> manageHook defaultConfig
        , logHook = dynamicLogWithPP $ defaultPP 
                 { 
                 ppCurrent           = dzenColor "#FFFFFF" "#0071FF"
                 , ppOutput          = hPutStrLn statuspipe
                 -- , ppVisible         = dzenColor "#8B80A8" ""
                 , ppHidden          = dzenColor "#FFFFFF" ""
                 , ppHiddenNoWindows = dzenColor "#4A4459" ""
                 -- , ppLayout          = dzenColor "#6B6382" ""
                 , ppSep             = "  "
                 , ppWsSep           = " "
                 , ppUrgent          = dzenColor "#0071FF" ""
                 -- , ppTitle           = dzenColor "#AA9DCF" "". shorten 700 . dzenEscape
                 }
        } `additionalKeysP` myKeys

myKeys :: [(String, X())]
myKeys = 
        [
        ("M-S-l", spawn "gnome-screensaver-command -l")
        ]

myFocusedBorderColor = "#F3D26B"
myNormalBorderColor = "#000000"
myDateBar = "conky | dzen2 -ta r -h 14 -w 1280 -x 1280 -bg black -fg white"
myScreensaver = "xscreensaver &"
myStartupHook = return ()
myTerminal :: String
myTerminal = "gnome-terminal --maximize"
