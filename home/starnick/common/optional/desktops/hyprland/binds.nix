#NOTE: Actions prepended with `hy3;` are specific to the hy3 hyprland plugin
{
  config,
  lib,
  pkgs,
  ...
}:
let
  mainMod = "SUPER";
in
{
  wayland.windowManager.hyprland.settings = {
    # Reference of supported bind flags: https://wiki.hyprland.org/Configuring/Binds/#bind-flags

    #
    # ========== Mouse Binds ==========
    #
    bindm = [
      # hold MAINMOD + leftlclick  to move/drag active window
      "${mainMod},mouse:272,movewindow"
      # hold MAINMOD + rightclick to resize active window
      "${mainMod},mouse:273,resizewindow"
    ];
    #
    # ========== Repeat Binds ==========
    #
    binde =
      let
        pactl = lib.getExe' pkgs.pulseaudio "pactl"; # installed via /hosts/common/optional/audio.nix
      in
      [
        # Resize active window 5 pixels in direction
        "${mainMod} ALT, h, resizeactive, -5 0"
        "${mainMod} ALT, j, resizeactive, 0 5"
        "${mainMod} ALT, k, resizeactive, 0 -5"
        "${mainMod} ALT, l, resizeactive, 5 0"

        #FIXME: repeat is not working for these
        # Volume - Output
        ", XF86AudioRaiseVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
        # Volume - Input
        ", XF86AudioRaiseVolume, exec, ${pactl} set-source-volume @DEFAULT_SOURCE@ +5%"
        ", XF86AudioLowerVolume, exec, ${pactl} set-source-volume @DEFAULT_SOURCE@ -5%"
      ];
    #
    # ========== One-shot Binds ==========
    #
    bind =
      let
        workspaces = [
          "1"
          "2"
          "3"
          "4"
          "5"
          "6"
          "7"
          "8"
          "9"
          "F1"
          "F2"
          "F3"
          "F4"
          "F5"
          "F6"
          "F7"
          "F8"
          "F9"
          "F10"
          "F11"
          "F12"
        ];
        # Map keys (arrows and hjkl) to hyprland directions (l, r, u, d)
        directions = rec {
          left = "l";
          right = "r";
          up = "u";
          down = "d";
          h = left;
          l = right;
          k = up;
          j = down;
        };
        pactl = lib.getExe' pkgs.pulseaudio "pactl"; # installed via /hosts/common/optional/audio.nix
        terminal = config.home.sessionVariables.TERM;
        editor = config.home.sessionVariables.EDITOR;
      in
      #playerctl = lib.getExe pkgs.playerctl; # installed via /home/common/optional/desktops/playerctl.nix
      #swaylock = "lib.getExe pkgs.swaylock;
      #makoctl = "${config.services.mako.package}/bin/makoctl";
      #gtk-play = "${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play";
      #notify-send = "${pkgs.libnotify}/bin/notify-send";
      #gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
      #xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
      # defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";
      # browser = defaultApp "x-scheme-handler/https";
      lib.flatten [
        #
        # ========== Quick Launch ==========
        #
        "${mainMod},R,exec,pkill rofi || rofi -show drun"
        "${mainMod},s,exec,pkill rofi || rofi -show ssh"
        "${mainMod},tab,exec,pkill rofi || rofi -show window"

        "${mainMod},T,exec,${terminal}"
        "${mainMod},I,exec,${terminal} ${editor}"
        "${mainMod},E,exec,thunar"
        "${mainMod},W,exec,firefox"
        "${mainMod},S,exec,stremio"

        #
        # ========== Screenshotting ==========
        #
        # TODO check on status of flameshot and multimonitor wayland. as of Oct 2024, it's a clusterfuck
        # so resorting to grimblast in the meantime
        #"CTRL_ALT,p,exec,flameshot gui"
        "${mainMod} SHIFT,S,exec,grimblast --notify --freeze copy area"
        ",Print,exec,grimblast --notify --freeze copy area"

        #
        # ========== Media Controls ==========
        #
        # see "binde" above for volume ctrls that need repeat binding
        # Output
        ", XF86AudioMute, exec, ${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
        # Input
        ", XF86AudioMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
        # Player
        #FIXME For some reason these key pressings aren't firing from Moonlander. Nothing shows when running wev
        ", XF86AudioPlay, exec, 'playerctl --ignore-player=firefox,chromium,brave play-pause'"
        ", XF86AudioNext, exec, 'playerctl --ignore-player=firefox,chromium,brave next'"
        ", XF86AudioPrev, exec, 'playerctl --ignore-player=firefox,chromium,brave previous'"

        #
        # ========== Windows and Groups ==========
        #
        #NOTE: window resizing is under "Repeat Binds" above

        # Close the focused/active window
        "${mainMod},q,killactive"

        # Fullscreen
        #"ALT,f,fullscreen,0" # 0 - fullscreen (takes your entire screen), 1 - maximize (keeps gaps and bar(s))
        # "ALT,f,fullscreenstate,2 -1" # `internal client`, where `internal` and `client` can be -1 - current, 0 - none, 1 - maximize, 2 - fullscreen, 3 - maximize and fullscreen
        "${mainMod}, ESCAPE, fullscreen"
        # Float
        "${mainMod},F,togglefloating"
        # Pin Active Floatting window
        # "SHIFTALT, p, pin, active" # pins a floating window (i.e. show it on all workspaces)

        # Splits groups
        # "ALT,v,hy3:makegroup,v" # make a vertical split
        # "SHIFTALT,v,hy3:makegroup,h" # make a horizontal split
        # "ALT,x,hy3:changegroup,opposite" # toggle btwn splits if untabbed
        # "ALT,s,togglesplit" # TODO: idk whats this

        # Tab groups
        # "ALT,g,hy3:changegroup,toggletab" # tab or untab the group
        #"ALT,t,lockactivegroup,toggle"
        # "ALT,apostrophe,changegroupactive,f"
        # "SHIFTALT,apostrophe,changegroupactive,b"

        #
        # ========== Workspaces ==========
        #
        # Change workspace
        (map (n: "${mainMod},${n},workspace,${n}") workspaces)
        "${mainMod}, 0, workspace, 10"
        "${mainMod},Y,workspace, empty"
        "${mainMod},h,workspace, r-1"
        "${mainMod},l,workspace, r+1"

        # Special/scratch
        "${mainMod},P, togglespecialworkspace"
        "${mainMod} SHIFT,P,movetoworkspace,special"
        "${mainMod} ALT,P,movetoworkspacesilent,special"

        # Move window to workspace
        # (map (n: "SHIFTALT,${n},hy3:movetoworkspace,{n}") workspaces)
        (map (n: "${mainMod} SHIFT,${n},movetoworkspace,${n}") workspaces)
        "${mainMod} SHIFT,l,movetoworkspace, r+1"
        "${mainMod} SHIFT,h,movetoworkspace, r-1"

        # Move window to first empty workspace
        "${mainMod} SHIFT,Y,movetoworkspace, empty"
        "${mainMod} CONTROL SHIFT,Y,movetoworkspacesilent, empty"

        # Move focus from active window to window in specified direction
        #(lib.mapAttrsToList (key: direction: "ALT,${key}, exec, customMoveFocus ${direction}") directions)
        (lib.mapAttrsToList (
          key: direction: "${mainMod} $CONTROL,${key},movefocus,${direction}"
        ) directions)

        # Move windows
        #(lib.mapAttrsToList (key: direction: "SHIFTALT,${key}, exec, customMoveWindow ${direction}") directions)
        # might be able to use this to replace move relative, to make it work between monitors
        # (lib.mapAttrsToList (key: direction: "SHIFTALT,${key},hy3:movewindow,${direction}") directions)

        # Move workspace to monitor in specified direction
        /*
          (lib.mapAttrsToList (
              key: direction: "CTRLSHIFT,${key},movecurrentworkspacetomonitor,${direction}"
            )
            directions)
        */

        #
        # ========== Monitors==========
        #
        "${mainMod}, m, exec, toggleMonitors"
        "${mainMod}, n, exec, toggleMonitorsNonPrimary"

        #
        # ========== Misc ==========
        #
        "SHIFTALT,r,exec,hyprctl reload" # reload the configuration file
        # "SUPER,l,exec,pidof hyprlock || hyprlock" # lock the wm
        "SUPER,O,exec,wlogout" # lock the wm
      ];
  };
}
