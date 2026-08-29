-- tip: run `stack update && stack build` to set up xmonad

import XMonad

import XMonad.Util.EZConfig (mkKeymap)
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Layout.IfMax (ifMax)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Spacing (smartSpacingWithEdge, Border (Border), spacingRaw)
import XMonad.Layout.BinarySpacePartition (emptyBSP, ResizeDirectional(ExpandTowards, ShrinkFrom), Rotate (Rotate))
import XMonad.Layout.Reflect (reflectHoriz, reflectVert)
import XMonad.Hooks.EwmhDesktops (ewmhFullscreen, ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts, docks)
import XMonad.Hooks.ManageHelpers (isDialog, doFullFloat, isFullscreen, doCenterFloat)
import XMonad.Actions.Navigation2D (windowGo, windowSwap)
import XMonad.Layout.ToggleLayouts (toggleLayouts)
import XMonad.Hooks.ServerMode (serverModeEventHookCmd')
import XMonad.Hooks.ManageHelpers (doRectFloat)
import System.Exit (exitSuccess)
import XMonad.Actions.ToggleFullFloat (toggleFullFloat, toggleFullFloatEwmhFullscreen)
import XMonad.Layout.Fullscreen (fullscreenFull)
import Control.Monad (when)
import XMonad.Hooks.Place (placeHook, simpleSmart)

import qualified Data.Map as M
import qualified XMonad.StackSet as W
import qualified XMonad.Actions.Submap as SM
import qualified XMonad.Actions.Navigation2D as N
import qualified XMonad.Util.ExtensibleState as XS


main :: IO ()
main = xmonad $ ewmhSupport $ docks $ myConfig
    where 
        ewmhSupport = toggleFullFloatEwmhFullscreen . ewmhFullscreen . ewmh


myConfig = def
    { 
      keys               = \conf -> mkKeymap conf myKeys,
      layoutHook         = myLayout,
      modMask            = myModMask,
      workspaces         = myWorkspaces,
      borderWidth        = myBorderWidth,
      normalBorderColor  = myNormalColor,
      focusedBorderColor = myFocusColor,
      startupHook        = myStartupHook,
      manageHook         = myManageHook <> placeHook simpleSmart <> manageHook def,
      handleEventHook    = serverModeEventHookCmd' myServerCommands <> handleEventHook def
    }
    where myModMask     = mod4Mask
          myBorderWidth = 2
          myNormalColor = "#282828"
          myFocusColor  = "#d4be98"
          myWorkspaces  = map show [1 .. 10 :: Int]


myLayout = avoidStruts $ smartBorders $ mySmartSpacing 7 $ (reflectVert . reflectHoriz) $ fullscreenFull $ emptyBSP
    where
        mySmartSpacing n l =
            ifMax 1 (spacingRaw True (Border 0 0 0 0) True (Border 0 0 0 0) True l)
                    (spacingRaw True (Border 0 n n n) True (Border n n n n) True l)


myServerCommands = pure
    [ ("test", spawn "notify-send 'Test'"), 
      ("exit", io exitSuccess) ]


myKeys :: [(String, X ())]
myKeys =
    [] 
    ++ [ ("M-<Return>", spawn "alacritty")
       , ("M-S-<Return>", spawn "alacritty --class=\"alacritty-float\"")
       , ("M-d", spawn "rofi -show drun")
       , ("M-<Tab>", spawn "rofi -show window -show-icons")
       , ("M-S-e", spawn "~/.config/rofi/scripts/system_prompt")
       ]
    ++ [ (modKey ++ key, windows $ f ws)
       | (modKey, f) <- [("M-", W.greedyView), ("M-S-", W.shift)]
       , (key, ws) <- zip (map show ([1 .. 9 :: Int] ++ [0])) (XMonad.workspaces myConfig)
       ]
    ++ [ (modKey ++ key, f dir True)
       | (modKey, f) <- [("M-", windowGo), ("M-S-", windowSwap)]
       , (key, dir) <- zip ["h", "j", "k", "l"] [N.L, N.D, N.U, N.R]
       ]
    ++ [ ("M-r", resizeMode)
       , ("M-S-r", spawn "xmonad --recompile && xmonad --restart")
       , ("M-<Space>", sendMessage Rotate)
       , ("M-S-<Space>", withFocused toggleFloat)
       , ("M-S-f", withFocused toggleFullFloat)
       , ("M-S-q", kill)
       ]
    ++
      [ ("<Print>",                 unGrab *> spawn "~/.scripts/print_screen")
      , ("<XF86MonBrightnessUp>",   spawn "brightnessctl set +10%; ~/.config/dunst/dunstify/br_notif")
      , ("<XF86MonBrightnessDown>", spawn ("test $((100 * $(brightnessctl get) / $(brightnessctl max))) -gt 0 && brightnessctl set 10%-;"
                                           ++ "~/.config/dunst/dunstify/br_notif"))
      , ("<XF86AudioRaiseVolume>",  spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%; ~/.config/dunst/dunstify/sink_notif @DEFAULT_SINK@")
      , ("<XF86AudioLowerVolume>",  spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%; ~/.config/dunst/dunstify/sink_notif @DEFAULT_SINK@")
      , ("<XF86AudioMute>",         spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle; ~/.config/dunst/dunstify/sink_notif @DEFAULT_SINK@")
      , ("<XF86AudioMicMute>",      spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle; ~/.config/dunst/dunstify/source_notif @DEFAULT_SOURCE@")
      , ("<XF86Display>",           spawn "xdotool search --class arandr windowclose || arandr")
      , ("<XF86Tools>",             spawn "xdotool search --class nm-connection-e windowclose || nm-connection-editor")
      ]
    where 
        setResizeMode :: Bool -> X ()
        setResizeMode enabled =
            io $ spawn $ "polybar-msg action resize-mode hook " ++ if enabled then "1" else "0"
        resizeMode :: X ()
        resizeMode = do
            setResizeMode True
            SM.submapDefault (setResizeMode False) . M.fromList $
                [ ((0, key), sendMessage (ExpandTowards dir) >> resizeMode)
                | (key, dir) <- zip [xK_h, xK_j, xK_k, xK_l] [N.L, N.D, N.U, N.R]
                ]
        toggleFloat win = windows (\s ->
                        if M.member win (W.floating s)
                        then W.sink win s
                        else (W.float win (W.RationalRect 0.30 0.20 0.40 0.60) s))


myStartupHook :: X ()
myStartupHook = do
    spawn "hsetroot -cover \"$(xdg-user-dir PICTURES)/Wallpapers/wallhaven-pkp1vp.png\""
    spawn "~/.config/dunst/dunstify/updates_notif"

    spawnOnRestart "~/.config/dunst/dunstify/restarted_notif xmonad"
    spawnOnRestart "polybar-msg cmd restart"

    spawnOnce "polybar"
    spawnOnce "redshift -l \"$(cat ~/.redshift-coord)\" >/dev/null"
    spawnOnce "xsetroot -cursor_name left_ptr"
    spawnOnce "xset s 600 600 dpms 0 0 660"
    spawnOnce "xss-lock -- ~/.scripts/i3lock_run"
    spawnOnce "caffeine"
    spawnOnce "picom"
    spawnOnce "udiskie --no-automount --no-notify --tray"
    spawnOnce "nm-applet"
    spawnOnce "/usr/libexec/polkit-gnome-authentication-agent-1"
    -- spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
    spawnOnce "~/.config/dunst/dunstify/bat_notif_run"


myManageHook :: ManageHook
myManageHook = composeAll
  [ title =? "todo"                     --> widget
  , className =? "alacritty"            --> medium
  , className =? "alacritty-float"      --> mediumFloat
  , className =? "kitty"                --> medium
  , className =? "kitty-float"          --> mediumFloat
  , className =? "Pavucontrol"          --> mediumFloat
  , className =? "Arandr"               --> mediumFloat
  , className =? "Nm-connection-editor" --> mediumFloat
  , className =? "firefox" <&&> stringProperty "WM_WINDOW_ROLE"
              =? "GtkFileChooserDialog" --> bigFloat
  , isDialog                            --> doFloat
  , isFullscreen                        --> (doF W.focusDown <+> doFullFloat)
  ]
  where
    medium      = doRectFloat (W.RationalRect 0.30 0.20 0.40 0.60)
    mediumFloat = doRectFloat (W.RationalRect 0.30 0.20 0.40 0.60)
    bigFloat    = doRectFloat (W.RationalRect 0.10 0.10 0.80 0.80)
    widget      = doRectFloat (W.RationalRect 0.69 0.55 0.30 0.40)


newtype HasStarted = HasStarted Bool
    deriving (Read, Show)

instance ExtensionClass HasStarted where
    initialValue = HasStarted False
    extensionType = PersistentExtension

spawnOnRestart :: String -> X ()
spawnOnRestart cmd = do
    HasStarted started <- XS.get
    XS.put (HasStarted True)
    when started (spawn cmd)
