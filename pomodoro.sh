#!/bin/zsh

function pomodoro_timer() {
    local work_time=25
    local break_time=5
    local sessions=4

    while [[ $# -gt 0 ]]; do
        case $1 in
            --work)
                work_time=$2
                shift 2
                ;;
            --break)
                break_time=$2
                shift 2
                ;;
            --sessions)
                sessions=$2
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                return 1
                ;;
        esac
    done

    function countdown() {
        local remaining=$1
        while [[ $remaining -gt 0 ]]; do
            printf "\rTime remaining: %02d:%02d" $((remaining / 60)) $((remaining % 60))
            sleep 1
            ((remaining--))
        done
    }

    for (( i = 1; i <= sessions; i++ )); do
        echo "\nSession $i: Work for $work_time minutes"
        countdown $(( work_time * 60 ))
        osascript -e 'display notification "Work time is over, take a break!" with title "Pomodoro Timer"'
        afplay /System/Library/Sounds/purr.aiff
        say "Time for a break!"

        if [[ $i -lt $sessions ]]; then
            echo "\nSession $i: Break for $break_time minutes"
            countdown $(( break_time * 60 ))
            osascript -e 'display notification "Break time is over, back to work!" with title "Pomodoro Timer"'
	          afplay /System/Library/Sounds/Purr.aiff
            say "Time to work! Lets go!"
        fi
    done

    echo ""
    osascript -e 'display notification "You have completed all sessions!" with title "Pomodoro Timer"'
	  afplay /System/Library/Sounds/Hero.aiff
    say "The pomodoro session is copleted!"
}

pomodoro_timer "$@"

