{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./binds.nix
    ./scripts.nix
    ./hyprlock.nix
    ./wlogout.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ]; # fix for https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
      # TODO(hyprland): experiment with whether this is required.
      # Same as default, but stop the graphical session too
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };

    settings = {
      #
      # ========== Environment Vars ==========
      #
      /*
        env = [
          "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
          "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
          "MOZ_WEBRENDER, 1" # for firefox to run on wayland
          "XDG_SESSION_TYPE,wayland"
          "WLR_NO_HARDWARE_CURSORS,1"
          "WLR_RENDERER_ALLOW_SOFTWARE,1"
          "QT_QPA_PLATFORM,wayland"
          "HYPRCURSOR_THEME,rose-pine-hyprcursor" # this will be better than default for now
        ];
      */

      #
      # ========== Monitor ==========
      #
      # parse the monitor spec defined in nix-config/home/<user>/<host>.nix
      monitor = (
        map (
          m:
          "${m.name},${
            if m.enabled then
              "${toString m.width}x${toString m.height}@${toString m.refreshRate}"
              + ",${toString m.x}x${toString m.y},1"
              + ",transform,${toString m.transform}"
              + ",vrr,${toString m.vrr}"
            else
              "disable"
          }"
        ) (config.monitors)
      );

      workspace = (
        let
          workspaceIDs = lib.flatten [
            (lib.range 1 10) # workspaces 1 through 10
            # "special" # add the special/scratchpad ws
          ];
        in
        # workspace structure to build "[workspace], monitor:[name], default:[bool], persistent:[bool]"
        map (
          ws:
          # map over workspace IDs first, then map over monitors to check for entries, and contact the empty
          # string elements created for ws and m combinations that don't match our actual conditions
          lib.concatMapStrings (
            m:
            # workspaces with a config.monitors assignment
            if toString ws == m.workspace then
              "${toString ws}, monitor:${m.name}, default:true, persistent:true"
            else
            # workspace 1 is persistent on the primary monitor
            if (ws == 1 || ws == "special") && m.primary == true then
              "${toString ws}, monitor:${m.name}, default:true, persistent:true"
            # FIXME(monitors): need logic to set primary as default monitor for workspaces that don't match above conditions but because we're limited to 'map' it seems to add more complexity than it's worth
            else
              ""
          ) config.monitors
        ) workspaceIDs
      );

      #
      # ========== Behavior ==========
      #
      binds = {
        workspace_center_on = 1; # Whether switching workspaces should center the cursor on the workspace (0) or on the last active window for that workspace (1)
        movefocus_cycles_fullscreen = false; # If enabled, when on a fullscreen window, movefocus will cycle fullscreen, if not, it will move the focus in a direction.
      };

      #
      # ========== Appearance ==========
      #
      #FIXME-rice colors conflict with stylix
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 0;
        #col.inactive-border = "0x00000000";
        #col.active-border = "0x0000000";
        # resize_on_border = true;
        # hover_icon_on_border = true;
        allow_tearing = true; # used to reduce latency and/or jitter in games
        /*
          col = {
            active_border = "rgb(ef1518) rgb(46a2d0) rgb(ee1616) 45deg";
            inactive-border = "rgb(9b8889)";
          };
        */

        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        # active_opacity = 1.0;
        # inactive_opacity = 0.85;
        # fullscreen_opacity = 1.0;
        blur = {
          enabled = true;
          # size = 4;
          # passes = 2;
          new_optimizations = true;
          # popups = true;
          xray = false;
        };
        shadow = {
          enabled = false;
          # range = 12;
          # offset = "3 3";
          #color = "0x88ff9400";
          #color_inactive = "0x8818141d";
        };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = true;
      };

      animations = {
        enabled = false;
      };
      # group = {
      #groupbar = {
      #          };
      #};

      #
      # ========== Auto Launch ==========
      #
      # exec-once = ''${startupScript}/path'';
      # To determine path, run `which foo`
      exec-once = [
        ''${pkgs.waypaper}/bin/waypaper --restore''
        ''[workspace 1 silent]${pkgs.spotify}/bin/spotify''
        ''[workspace 2 silent]${pkgs.vesktop}/bin/vesktop''
        ''[workspace 3 silent]${pkgs.kitty}/bin/kitty''
      ];
      #
      # ========== Layer Rules ==========
      #
      layer = [
        #"blur, rofi"
        #"ignorezero, rofi"
        #"ignorezero, logout_dialog"
      ];
      #
      # ========== Window Rules ==========
      #
      windowrule = [
        # Dialogs
        "float, title:^(Open File)(.*)$"
        "float, title:^(Select a File)(.*)$"
        "float, title:^(Choose wallpaper)(.*)$"
        "float, title:^(Open Folder)(.*)$"
        "float, title:^(Save As)(.*)$"
        "float, title:^(Library)(.*)$"
        "float, title:^(Accounts)(.*)$"
      ];
      windowrulev2 = [
        "float, class:^(galculator)$"
        "float, class:^(waypaper)$"
        #"float, class:^(keymapp)$"
        #"float, class:^(yubioath-flutter)$"

        #
        # ========== Always opaque ==========
        #
        "opaque, class:^([Gg]imp)$"
        "opaque, class:^([Ff]lameshot)$"
        "opaque, class:^([Ii]nkscape)$"
        "opaque, class:^([Bb]lender)$"
        "opaque, class:^([Oo][Bb][Ss])$"
        "opaque, class:^([Ss]team)$"
        "opaque, class:^([Ss]team_app_*)$"
        "opaque, class:^([Vv]lc)$"

        # Remove transparency from video
        "opaque, title:^(Netflix)(.*)$"
        "opaque, title:^(.*YouTube.*)$"
        "opaque, title:^(Picture-in-Picture)$"
        #
        # ========== Scratch rules ==========
        #
        #"size 80% 85%, workspace:^(special)$"
        #"center, workspace:^(special)$"

        #
        # ========== Steam rules ==========
        #
        #FIXME(steam): testing with stayfocused disabled.
        #"stayfocused, title:^()$,class:^([Ss]team)$"
        "minsize 1 1, title:^()$,class:^([Ss]team)$"
        "immediate, class:^([Ss]team_app_*)$"
        "workspace 7, class:^([Ss]team_app_*)$"
        "monitor 0, class:^([Ss]team_app_*)$"

        #
        # ========== Fameshot rules ==========
        #
        # flameshot currently doesn't have great wayland support so needs some tweaks
        #"rounding 0, class:^([Ff]lameshot)$"
        #"noborder, class:^([Ff]lameshot)$"
        #"float, class:^([Ff]lameshot)$"
        #"move 0 0, class:^([Ff]lameshot)$"
        #"suppressevent fullscreen, class:^([Ff]lameshot)$"
        # "monitor:DP-1, ${flameshot}"

        #
        # ========== Workspace Assignments ==========
        #
        "workspace 8, class:^(virt-manager)$"
        "workspace 8, class:^(obsidian)$"
        "workspace 9, class:^(brave-browser)$"
        "workspace 9, class:^(signal)$"
        "workspace 9, class:^(org.telegram.desktop)$"
        "workspace 9, class:^(discord)$"
        "workspace 0, title:^([Ss]potify*)$"
      ];
    };
  };
}
