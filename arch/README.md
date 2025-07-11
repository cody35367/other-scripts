# 20250710 Setup Notes
- Add the following to ~/.bashrc
```bash
# Add ~/.local/bin to PATH if it's not already there and the directory exists
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
```
- Run BDO Launch Options in Steam
```shell
rm "/home/chodges/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Black Desert Online/bin64/XignCode/NA/1/xmag_x64.xem"; %command%
```