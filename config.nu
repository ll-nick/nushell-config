$env.config.show_banner = false

# Configure vi mode and use cursor shape to indicate mode
$env.config.edit_mode = 'vi'
$env.config.cursor_shape = {
    vi_insert: line
    vi_normal: block
    emacs: underscore
  }
$env.PROMPT_INDICATOR_VI_NORMAL = ''
$env.PROMPT_INDICATOR_VI_INSERT = ''

# Clear line with Ctrl+U
$env.config.keybindings ++= [{
    name: clear-line
    modifier: CONTROL
    keycode: Char_u
    mode: vi_insert
    event: [
        { edit: Clear }
    ]
}]

alias fg = job unfreeze
alias ll = ls --all --long
