## If `boltflow.sh` is not executable

```bash
./boltflow.sh
zsh: permission denied: ./boltflow.sh
```

Fix by re-applying the executable bit on the `boltflow` file: `chmod a+x boltflow.sh`.

## Obscure errors when running boltflow

You might, in some edge cases, run into errors like this one:

```bash
[ErrorException]
  "continue" targeting switch is equivalent to "break". Did you mean to use "continue 2"?
```
In that case, remove `/composer.phar`, `/composer.lock`, `extensions/composer.lock` and `/vendor`. This will remove any bitrot and you will get new files of these when you run boltflow again. 

Remove by running:

```bash
rm composer.lock
rm composer.phar
rm extensions/composer.lock
rm -rf vendor
```
Now run boltflow again.
