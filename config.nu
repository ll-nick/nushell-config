source themes/catppuccin_mocha.nu

$env.config.show_banner = false

# History settings
$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 5_000_000
$env.config.history.sync_on_enter = true
$env.config.history.isolation = true

# Configure vi mode and use cursor shape to indicate mode
$env.config.edit_mode = 'vi'
$env.config.cursor_shape = {
    vi_insert: line
    vi_normal: block
    emacs: underscore
  }
$env.PROMPT_INDICATOR_VI_NORMAL = ''
$env.PROMPT_INDICATOR_VI_INSERT = ''

$env.config.keybindings ++= [
    # Clear line with Ctrl+U
    {
        name: clear-line
        modifier: CONTROL
        keycode: Char_u
        mode: [ vi_normal vi_insert ]
        event: [
            { edit: Clear }
        ]
    },
    # Navigate command history with Alt+K and Alt+J
    {
        name: previous-command
        modifier: ALT
        keycode: Char_k
        mode: [ vi_normal vi_insert ]
        event: [
            { send: Up }
        ]
    },
    {
        name: next-command
        modifier: ALT
        keycode: Char_j
        mode: [ vi_normal vi_insert ]
        event: [
            { send: Down }
        ]
    }
]

alias fg = job unfreeze
alias ll = ls --all --long

# Adjust completion menu colors
$env.config.menus ++= [{
    name: completion_menu
    only_buffer_difference: false
    marker: "| "
    type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
    }
    style: {
        text: { fg: $theme_palette.blue }
        selected_text: { fg: $theme_palette.base bg: $theme_palette.blue }
        description_text: { fg: $theme_palette.text }
        match_text: {  attr: "u"}
    }
}]

