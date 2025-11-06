#!/usr/bin/env nu

export def main [] {
    let sep = char unit_separator
    let history = open $nu.history-path | query db "select distinct command_line, start_timestamp, duration_ms, exit_status, cwd from history group by command_line order by max(start_timestamp) desc"
    let formatted = (
        $history
        | each {|row|
            let status = if $row.exit_status == 0 { "" } else { "" } | fill --width 3
            $"($status)($sep)($row.command_line)($sep)($row.start_timestamp)($sep)($row.cwd)($sep)($row.duration_ms)"
        }
        | str join (char -i 0)
    )

    let selected = (
        $formatted
        | fzf
            --read0
            --with-nth=1,2
            --accept-nth=2
            --delimiter=$"($sep)"
            --scheme=history
            -q (commandline)
            --height=40%
            --preview-window='bottom:5:nowrap'
            --preview '
                {} | split column (char unit_separator) exit_status Command Timestamp Directory Duration
                | update Timestamp {|it| $it.Timestamp | into int | $in / 1000 | math round | into datetime --format "%s" }
                | update Duration {|it| $it.Duration | into duration --unit ms }
                | reject Command
                '
        | decode utf-8
        | str trim
    )

    commandline edit --replace $selected
}
