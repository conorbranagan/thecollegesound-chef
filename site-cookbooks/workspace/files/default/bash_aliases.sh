alias ..="cd .."

alias_if_exists () {
    which $1 &> /dev/null
    if [ $? -eq 0 ]
    then
        alias $2="$1"
    fi
}

# Ubuntu aliases.
alias_if_exists "ack-grep" "ack"
