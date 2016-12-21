Boltflow - introduction
=======================

These documents describe my preferred way of working with Bolt, when it comes to
the “dev ops” part of the process. So, the workflow of how to set up a Bolt
instal in such a way that it’s pleasant to work with, easy to upgrade, and
simple to deploy on a client’s server.

Feel free to mix-and-match parts of this workflow to suit your own needs. You
might prefer working in a different manner, or your environments are set up in a
different manner.

Boltflow is centered around the following concepts:

 - Composer is a great tool for dependency management. Bolt uses a _ton_ of
   Composer packages. In fact, Bolt itself is a Composer package.
 - Version control using Git is great.
 - The Command Line is not scary. In fact, the command line often allows you to
   work _faster_ than when you’re using a GUI, and it also give you greater
   control and a deeper understanding of what you’re doing.
 - We'll use a "local" development environment, and use a deploy strategy to
   put the project "live" in production.

So, Boltflow leverages these concepts to provide a quick and friendly workflow
for your Bolt projects:

 - We’ll only store the project-specific files in git, to keep our repository
   small, fast and manageable. Files like templates, configuration and other
   assets go in git. The rest will be “composered in”, when needed.
 - We use composer extensively. Initially to fetch Bolt files and its
   dependencies, but also to _update_ Bolt, components and Bolt Extensions to
   newer versions. When deploying a website, we’ll use Composer to deploy the
   website, in the exact same state as it was on the development environment.
 - Boltflow comes with the `boltflow.sh` command line utility. Together with
   `git` and `composer`, we leverage the power of the CLI to work efficiently.

Boltflow is divided into three parts, with one appendix:

 - [Setting up a project](Setting up a project.md)
 - [Working in / updating a project](Working + updating a project.md)
 - [Deploying a project](Deploying a project.md)
 - Appenix: [Boltflow checklist](Development Checklist.md)

-----------

Want to gain more knowledge on some of the technologies used in this document? Fret not, because I have compiled a small list of links with additional information:

 - 📹 [Command Line Power User][clipu]
 - 📄 [git - the simple guide][gitguide]
 - 📖💵 [Git for humans][gitforhumans] by A Book Apart

[clipu]: http://commandlinepoweruser.com/
[gitguide]: http://rogerdudler.github.io/git-guide/
[gitforhumans]: https://abookapart.com/products/git-for-humans
