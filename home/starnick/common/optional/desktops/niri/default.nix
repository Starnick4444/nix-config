{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  binds =
    {
      suffixes,
      prefixes,
      substitutions ? { },
    }:
    let
      replacer = replaceStrings (attrNames substitutions) (attrValues substitutions);
      format =
        prefix: suffix:
        let
          actual-suffix =
            if isList suffix.action then
              {
                action = head suffix.action;
                args = tail suffix.action;
              }
            else
              {
                inherit (suffix) action;
                args = [ ];
              };

          action = replacer "${prefix.action}-${actual-suffix.action}";
        in
        {
          name = "${prefix.key}+${suffix.key}";
          value.action.${action} = actual-suffix.args;
        };
      pairs =
        attrs: fn:
        concatMap (
          key:
          fn {
            inherit key;
            action = attrs.${key};
          }
        ) (attrNames attrs);
    in
    listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [ (format prefix suffix) ])));
in
{
  programs.niri.settings = {
    # input.keyboard.xkb.layout = "no";
    input.touchpad = {
      tap = true;
      dwt = true;
      natural-scroll = true;
      click-method = "clickfinger";
    };

    prefer-no-csd = true;

    layout = {
      gaps = 8;
      struts.left = 64;
      struts.right = 64;
      border.width = 1;
      always-center-single-column = true;

      empty-workspace-above-first = true;

      shadow.enable = true;

      tab-indicator = {
        position = "top";
        gaps-between-tabs = 10;
      };
    };

    hotkey-overlay.skip-at-startup = true;
    # TODO: whats this?
    clipboard.disable-primary = true;

    overview.zoom = 0.5;

    screenshot-path = "~/media/images/Screenshots/%Y-%m-%dT%H:%M:%S.png";

    switch-events =
      with config.lib.niri.actions;
      let
        sh = spawn "sh" "-c";
      in
      {
        tablet-mode-on.action = sh "notify-send tablet-mode-on";
        tablet-mode-off.action = sh "notify-send tablet-mode-off";
        lid-open.action = sh "notify-send lid-open";
        lid-close.action = sh "notify-send lid-close";
      };

    binds =
      with config.lib.niri.actions;
      let
        sh = spawn "sh" "-c";
      in
      lib.attrsets.mergeAttrsList [
        {
          "Mod+T".action = spawn "kitty";
          "Mod+O".action = show-hotkey-overlay;
          "Mod+D".action = spawn "fuzzel";
          "Mod+W".action = spawn "firefox";

          # "Mod+L".action = spawn "blurred-locker";
          "Mod+Semicolon".action = spawn "wlogout";

          "Mod+Shift+S".action = screenshot;
          "Print".action.screenshot-screen = [ ];
          "Mod+Print".action = screenshot-window;

          "Mod+Insert".action = set-dynamic-cast-window;
          "Mod+Shift+Insert".action = set-dynamic-cast-monitor;
          "Mod+Delete".action = clear-dynamic-cast-target;

          "XF86AudioRaiseVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
          "XF86AudioLowerVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          "XF86AudioMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

          "XF86MonBrightnessUp".action = sh "brightnessctl set 10%+";
          "XF86MonBrightnessDown".action = sh "brightnessctl set 10%-";

          "Mod+Q".action = close-window;

          "Mod+Space".action = toggle-column-tabbed-display;
          "Mod+Slash".action = toggle-overview;

          "XF86AudioNext".action = focus-column-right;
          "XF86AudioPrev".action = focus-column-left;

          "Mod+Tab".action = focus-window-down-or-column-right;
          "Mod+Shift+Tab".action = focus-window-up-or-column-left;
        }
        (binds {
          suffixes."Left" = "column-left";
          suffixes."Down" = "window-down";
          suffixes."Up" = "window-up";
          suffixes."Right" = "column-right";
          suffixes."H" = "column-left";
          suffixes."L" = "column-right";
          prefixes."Mod" = "focus";
          prefixes."Mod+Ctrl" = "move";
          prefixes."Mod+Shift" = "focus-monitor";
          prefixes."Mod+Shift+Ctrl" = "move-window-to-monitor";
          substitutions."monitor-column" = "monitor";
          substitutions."monitor-window" = "monitor";
        })
        {
          "Mod+V".action = switch-focus-between-floating-and-tiling;
          "Mod+Shift+V".action = toggle-window-floating;
        }
        (binds {
          suffixes."Home" = "first";
          suffixes."End" = "last";
          prefixes."Mod" = "focus-column";
          prefixes."Mod+Ctrl" = "move-column-to";
        })
        (binds {
          suffixes."J" = "workspace-down";
          suffixes."K" = "workspace-up";
          prefixes."Mod" = "focus";
          prefixes."Mod+Ctrl" = "move-window-to";
          prefixes."Mod+Shift" = "move";
        })
        (binds {
          suffixes = builtins.listToAttrs (
            map (n: {
              name = toString n;
              value = [
                "workspace"
                (n + 1)
              ]; # workspace 1 is empty; workspace 2 is the logical first.
            }) (range 1 9)
          );
          prefixes."Mod" = "focus";
          prefixes."Mod+Ctrl" = "move-window-to";
        })
        {
          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;

          "Mod+R".action = switch-preset-column-width;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;
          "Mod+C".action = center-column;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Plus".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Plus".action = set-window-height "+10%";

          "Mod+Shift+Escape".action = toggle-keyboard-shortcuts-inhibit;
          "Mod+Shift+E".action = quit;
          "Mod+Shift+P".action = power-off-monitors;

          "Mod+Shift+Ctrl+T".action = toggle-debug-tint;
        }
      ];

    # custom shader??

    window-rules =
      let
        colors = config.lib.stylix.colors.withHashtag;
      in
      [
        {
          draw-border-with-background = false;
          geometry-corner-radius =
            let
              r = 8.0;
            in
            {
              top-left = r;
              top-right = r;
              bottom-left = r;
              bottom-right = r;
            };
          clip-to-geometry = true;
        }
        {
          matches = [
            {
              app-id = "^kitty$";
              title = ''^\[oxygen\]'';
            }
          ];
          border.active.color = colors.base0B;
        }
        {
          matches = [
            {
              app-id = "^firefox$";
              title = "Private Browsing";
            }
          ];
          border.active.color = colors.base0E;
        }
        {
          matches = [
            {
              app-id = "^signal$";
            }
          ];
          block-out-from = "screencast";
        }
      ];
    gestures.dnd-edge-view-scroll = {
      trigger-width = 64;
      delay-ms = 250;
      max-speed = 12000;
    };

    layer-rules = [
      {
        matches = [ { namespace = "^swaync-notification-window$"; } ];

        block-out-from = "screencast";
      }
      {
        matches = [ { namespace = "^swww-daemonoverview$"; } ];

        place-within-backdrop = true;
      }
    ];
    # xwayland-satellite.path = "${lib.getExe pkgs.xwayland-satellite-unstable}";

    # personal settings, maybe per machine?
    # TODO: idk what is the layout called
    # input.keyboard.xkb.layout = ""
    layout = {
      preset-column-widths = [
        { proportion = 1.0 / 6.0; }
        { proportion = 1.0 / 4.0; }
        { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 2.0; }
        { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 4.0; }
        { proportion = 1.0 / 6.0; }
      ];
      default-column-width = {
        proportion = 1.0 / 3.0;
      };
    };

    outputs =
      let
        cfg = config.programs.niri.settings.outputs;
      in
      {
        "HDMI-A-1" = {
          mode.width = 1920;
          mode.height = 1080;
          mode.refresh = 75.0;
          position.x = 0;
          position.y = -cfg."HDMI-A-1".mode.height;
        };
      };

    spawn-at-startup =
      let
        waybar-config = toString config.xdg.configFile."waybar/config".source;
        waybar-style = toString config.xdg.configFile."waybar/style.css".source;
      in
      [
        {
          command = [
            (lib.getExe pkgs.waybar)
            "-c"
            waybar-config
            "-s"
            waybar-style
          ];
        }
        # {
        #   command = [ (lib.getExe pkgs.spotify) ];
        # }
        {
          command = [ (lib.getExe pkgs.vesktop) ];
        }
        {
          command = [
            (lib.getExe pkgs.waypaper)
            "--restore"
          ];
        }
        {
          command = [
            (lib.getExe pkgs.xwayland-satellite)
          ];
        }
      ];

    environment = {
      DISPLAY = ":0";
    };
  };

  home.packages = with pkgs; [
    libnotify
  ];

  programs.fuzzel = {
    enable = true;
    settings.main.launch-prefix = "niri msg action spawn --";
    settings.main.terminal = "foot";
  };

  programs.wlogout.enable = true;

  #https://github.com/sodiboo/system/blob/fc90e0d3a939ca0147b3b9bd8fd8596b06f60cf5/personal/niri.mod.nix#L38
}
