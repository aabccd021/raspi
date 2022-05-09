scp -r ./nixos raspi:/etc \
&& ssh raspi "nixos-rebuild switch && reboot"

