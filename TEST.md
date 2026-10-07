### Tests using Docker

`install-arch.sh` refuses to run as root, so the container needs a regular user with passwordless sudo. There is no systemd inside the container: the script skips `docker.socket` and `hypridle.service` with a warning, which is expected.

**1. Start a clean Arch container with the repo mounted read-only:**

```bash
docker run -it --rm --name arch-test -v "$HOME/dotfiles:/repo:ro" archlinux bash
```

**2. Create a user and copy the repo (inside the container):**

```bash
pacman -Syu --noconfirm --needed sudo
useradd -m -s /bin/bash tester
echo 'tester ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/tester
cp -r /repo /home/tester/dotfiles
rm -f /home/tester/dotfiles/config/hypr/local.lua   # simulate a fresh clone
chown -R tester:tester /home/tester/dotfiles
```

**3. Run the installer as that user:**

```bash
su - tester -c 'cd ~/dotfiles && ./install-arch.sh'
```

**4. Check the result:**

- Run it a second time: no `Backup created` lines should appear.
- `ls -l ~/.config ~/.local/bin ~/Images/Wallpapers` shows symlinks into `~/dotfiles`.
- `zsh -ic exit` prints no errors.
- `nvim --headless "+Lazy! restore" +qa` installs the plugins; afterwards `nvim --headless +qa` prints nothing.

----

### ToDo

- [ ] Neovim Theme
- [ ] Laptop installation
