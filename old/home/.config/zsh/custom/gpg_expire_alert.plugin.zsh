#!/usr/bin/env zsh
# this script checks for expired gpg keys and if they exist it prints an alert
local expired_keys
expired_keys=$(gpg --list-keys --with-colons | awk -F: '/^pub/{print $6}')

if [[ -n "$expired_keys" ]]; then
    echo "Warning: You have expired GPG keys. Please renew or generate new keys."
    echo "Expired Key IDs: $expired_keys"
    echo "To renew a key, run: gpg --edit-key [key-id], then use the 'expire' command."
    echo "To generate a new key, run: gpg --full-generate-key"
fi
