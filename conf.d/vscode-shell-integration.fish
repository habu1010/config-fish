if status is-interactive
    string match -q "$TERM_PROGRAM" "vscode"
    and source (code --locate-shell-integration-path fish)
end
