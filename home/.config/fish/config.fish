set -g fish_greeting ''

if status is-interactive
    # Commands to run in interactive sessions can go here

    # Make sure ssh-add can connect to the agent.
    set -x SSH_AUTH_SOCK (systemctl --user show-environment | grep SSH_AUTH_SOCK | cut -d '=' -f2)

    # zellij
    # currently having trouble with keybindings
    # eval (zellij setup --generate-auto-start fish | string collect)

    # tmux
    if not set -q TMUX
        # Attach to first available session, or create new.
        set -l sessions "$(tmux ls -F '#{session_name}|#{?session_attached,attached,not attached}')"
        set -l available "$(echo $sessions | grep 'not attached')"
        if test $status -eq 0
            set -l first_avail (echo $available | tail -n 1 | cut -d '|' -f1)
            tmux attach -t $first_avail
        else
            tmux
        end
    end
end

fish_add_path ~/.cargo/bin

# Variables

set -g EDITOR 'hx'

# Aliases

alias ls='lsd'

function tryedit -d "Make a file writable in-place while creating a backup"
    set -l f $argv[1]

    # Make sure the backup is identical to the original, including permissions.
    mv $f $f.bak
    # This should follow symlinks.
    cp $f.bak $f
    chmod +w $f
end

function untryedit -d "Restore from a backup created by tryedit"
    set -l f $argv[1]

    if test -e $f.bak
        rm $f
        mv $f.bak $f
    end
end

# McFly history search
mcfly init fish | source

# Better cd
zoxide init fish | source

# Shell prompt
#
# Disabled for being slow in large Git repos
#
# starship init fish | source

direnv hook fish | source
