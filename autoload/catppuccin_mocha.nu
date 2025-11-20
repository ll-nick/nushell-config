export const theme_palette = {
    rosewater: "#f5e0dc"
    flamingo: "#f2cdcd"
    pink: "#f5c2e7"
    mauve: "#cba6f7"
    red: "#f38ba8"
    maroon: "#eba0ac"
    peach: "#fab387"
    yellow: "#f9e2af"
    green: "#a6e3a1"
    teal: "#94e2d5"
    sky: "#89dceb"
    sapphire: "#74c7ec"
    blue: "#89b4fa"
    lavender: "#b4befe"
    text: "#cdd6f4"
    subtext1: "#bac2de"
    subtext0: "#a6adc8"
    overlay2: "#9399b2"
    overlay1: "#7f849c"
    overlay0: "#6c7086"
    surface2: "#585b70"
    surface1: "#45475a"
    surface0: "#313244"
    base: "#1e1e2e"
    mantle: "#181825"
    crust: "#11111b"
}

# Retrieve the theme settings
export def main [] {
    return {
        separator: $theme_palette.overlay0
        leading_trailing_space_bg: { attr: "n" }
        header: { fg: $theme_palette.blue attr: "b" }
        empty: $theme_palette.lavender
        bool: $theme_palette.lavender
        int: $theme_palette.peach
        duration: $theme_palette.text
        filesize: {|e|
            if $e < 1mb {
                $theme_palette.green
            } else if $e < 100mb {
                $theme_palette.yellow
            } else if $e < 500mb {
                $theme_palette.peach
            } else if $e < 800mb {
                $theme_palette.maroon
            } else if $e > 800mb {
                $theme_palette.red
            }
        }
        datetime: {|| (date now) - $in |
            if $in < 1hr {
                $theme_palette.green
            } else if $in < 1day {
                $theme_palette.yellow
            } else if $in < 3day {
                $theme_palette.peach
            } else if $in < 1wk {
                $theme_palette.maroon
            } else if $in > 1wk {
                $theme_palette.red
            }
        }
        range: $theme_palette.text
        float: $theme_palette.text
        string: $theme_palette.text
        nothing: $theme_palette.text
        binary: $theme_palette.text
        'cell-path': $theme_palette.text
        row_index: { fg: $theme_palette.mauve attr: "b" }
        record: $theme_palette.text
        list: $theme_palette.text
        block: $theme_palette.text
        hints: $theme_palette.overlay1
        search_result: { fg: $theme_palette.red bg: $theme_palette.text }

        shape_and: { fg: $theme_palette.pink attr: "b" }
        shape_binary: { fg: $theme_palette.pink attr: "b" }
        shape_block: { fg: $theme_palette.blue attr: "b" }
        shape_bool: $theme_palette.teal
        shape_custom: $theme_palette.green
        shape_datetime: { fg: $theme_palette.teal attr: "b" }
        shape_directory: $theme_palette.teal
        shape_external: $theme_palette.teal
        shape_externalarg: { fg: $theme_palette.green attr: "b" }
        shape_filepath: $theme_palette.teal
        shape_flag: { fg: $theme_palette.blue attr: "b" }
        shape_float: { fg: $theme_palette.pink attr: "b" }
        shape_garbage: { fg: $theme_palette.text bg: $theme_palette.red attr: "b" }
        shape_globpattern: { fg: $theme_palette.teal attr: "b" }
        shape_int: { fg: $theme_palette.pink attr: "b" }
        shape_internalcall: { fg: $theme_palette.teal attr: "b" }
        shape_list: { fg: $theme_palette.teal attr: "b" }
        shape_literal: $theme_palette.blue
        shape_match_pattern: $theme_palette.green
        shape_matching_brackets: { attr: "u" }
        shape_nothing: $theme_palette.teal
        shape_operator: $theme_palette.peach
        shape_or: { fg: $theme_palette.pink attr: "b" }
        shape_pipe: { fg: $theme_palette.pink attr: "b" }
        shape_range: { fg: $theme_palette.peach attr: "b" }
        shape_record: { fg: $theme_palette.teal attr: "b" }
        shape_redirection: { fg: $theme_palette.pink attr: "b" }
        shape_signature: { fg: $theme_palette.green attr: "b" }
        shape_string: $theme_palette.green
        shape_string_interpolation: { fg: $theme_palette.teal attr: "b" }
        shape_table: { fg: $theme_palette.blue attr: "b" }
        shape_variable: $theme_palette.pink

        background: $theme_palette.base
        foreground: $theme_palette.text
        cursor: $theme_palette.blue
    }
}

# Update the Nushell configuration
export def --env "set color_config" [] {
    $env.config.color_config = (main)
}

# Update terminal colors
export def "update terminal" [] {
    let theme = (main)

    # Set terminal colors
    let osc_screen_foreground_color = '10;'
    let osc_screen_background_color = '11;'
    let osc_cursor_color = '12;'
        
    $"
    (ansi -o $osc_screen_foreground_color)($theme.foreground)(char bel)
    (ansi -o $osc_screen_background_color)($theme.background)(char bel)
    (ansi -o $osc_cursor_color)($theme.cursor)(char bel)
    "
    # Line breaks above are just for source readability
    # but create extra whitespace when activating. Collapse
    # to one line and print with no-newline
    | str replace --all "\n" ''
    | print -n $"($in)\r"
}

export module activate {
    export-env {
        set color_config
        update terminal
    }
}

# Activate the theme when sourced
use activate
