{ config, pkgs, ... }:

let
  userName = config.home.username;
  userConfigPath = ../../users + "/${userName}/dotfiles/qtile/config.py";
  userConfigExists = builtins.pathExists userConfigPath;

  baseConfig = pkgs.writeText "qtile-base-config.py" ''
    from libqtile import bar, layout, widget
    from libqtile.config import Click, Drag, Group, Key, Screen
    from libqtile.lazy import lazy

    mod = "mod4"
    terminal = "alacritty"

    keys = [
        Key([mod], "Return", lazy.spawn(terminal)),
        Key([mod], "q", lazy.window.kill()),
        Key([mod], "r", lazy.restart()),
        Key([mod], "Tab", lazy.next_layout()),
        Key([mod], "h", lazy.layout.left()),
        Key([mod], "l", lazy.layout.right()),
        Key([mod], "j", lazy.layout.down()),
        Key([mod], "k", lazy.layout.up()),
    ]

    groups = [Group(str(i)) for i in range(1, 10)]
    for group in groups:
        keys.extend([
            Key([mod], group.name, lazy.group[group.name].toscreen()),
            Key([mod, "shift"], group.name, lazy.window.togroup(group.name)),
        ])

    layouts = [
        layout.Columns(),
        layout.Max(),
    ]

    widget_defaults = dict(
        fontsize=12,
        padding=6,
    )
    extension_defaults = widget_defaults.copy()

    screens = [
        Screen(
            top=bar.Bar(
                [
                    widget.GroupBox(),
                    widget.Prompt(),
                    widget.WindowName(),
                    widget.Systray(),
                    widget.Clock(format="%Y-%m-%d %H:%M"),
                ],
                24,
            ),
        ),
    ]

    mouse = [
        Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
        Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
        Click([mod], "Button2", lazy.window.bring_to_front()),
    ]

    dgroups_key_binder = None
    dgroups_app_rules = []
    follow_mouse_focus = True
    bring_front_click = False
    cursor_warp = False
    floating_layout = layout.Floating()
    auto_fullscreen = True
    focus_on_window_activation = "smart"
    reconfigure_screens = True
    auto_minimize = True
    wmname = "LG3D"
  '';
in
{
  xdg.configFile."qtile/config.py".source =
    if userConfigExists then userConfigPath else baseConfig;
}
