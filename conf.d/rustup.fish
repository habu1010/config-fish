set rustup_env_file "$HOME/.cargo/env.fish"

if test -f $rustup_env_file
    source $rustup_env_file
end
