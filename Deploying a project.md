Boltflow - Deploying a project
==============================

When it's time do deploy,

Deploy Key
----------

On your production (and acceptence) environment, you should never have to
_commit_ anything to the git repository. The only thing you'll do is _pull_
from the repo. If possible, you should set up just a 'deploy key' for your git
repo. This will allow the server environment to read from the repo, but not
to write back to it.

To do this, you'll need to create a private / public key pair, and add the _public_ key as a deploy key to either Gitlab or Github.

### Check for a key
First, check if your hosting environment already has a key pair set up: `ls -als ~/.ssh/`. If any files like `id_rsa.pub` or `github_rsa.pub` show up, you're set. Make sure you want to have an RSA key, and not an old fashioned DSA key.

### Create a key
Make a key, if you don't yet have one. Use the command `ssh-keygen -t rsa -b 4096`, and press enter a few times, accepting the default values.


- Copy over your database (either dump & import, or just copy over the file
  from your `app/database/` folder.)

Ideally, you'll set up _two_ identical environments on the server. This way you
can have an "Acceptence" and a "Production" environment. In this case you'll
deploy to ACC first, and (have the client) verify nothing has broken. It that
goes well, only then run the deploy on production. Doing this will reduce the
chance of breaking websites and downtime.

Run:

```
./boltflow.sh --dry-run
```

If this doesn't produce any errors, run the deploy for real:

```
./boltflow.sh
```

