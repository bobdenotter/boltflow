Boltflow - Working in / updating a project
==========================================

One of the core concepts of Boltflow is ease of use when it comes to working
with a project, moving it to another working environment, and updating the used
components.

In order to do this, we’re going to use a simple shell script, that does a few
things:

* It does a `git pull` to make sure you’re current with upstream.
* It creates the cache folders, if they’re not present.
* It changes the file rights on the template folders, cache folders, etc.
* It fetches all required composer packages.
* It installs all required bolt extensions.

To run it, simply issue the command below:

```
./boltflow.sh
```

If you’re working on a project in a team, you might be working in your own
branch, or you might not.

To update the current version of Bolt to the latest stable version, run the
following:

```
./boltflow.sh update
```

This will fetch the latest versions of Bolt and dependent composer packages, for
your development environment. You can test if everything works as expected. If
so, propagate the change into git by committing the updated `composer.lock`
files:

```
git add composer.lock extensions/composer.lock
git commit -m "Updating Bolt, Bolt extensions and Composer packages."
git push
```

If the change breaks your project, you can revert to the last known stable
situation, like this:

```
git checkout -- composer.lock
git checkout -- extensions/composer.lock
./boltflow.sh
```

This will revert the two `.lock` files to the version in git, and it will run
the ‘install’ process to fetch the dependencies to match the previous state.
