## If `boltflow.sh` is not executable

```bash
./boltflow.sh
zsh: permission denied: ./boltflow.sh
```

Fix by re-applying the executable bit on the `boltflow` file: `chmod a+x boltflow.sh`.

