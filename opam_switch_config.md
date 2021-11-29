# Why work with different opam configurations?

Since you may have to work with different projects, in particular switching between the repositories of the **bs** project and those of **ocsigen** (in our case), it is important to be able to change the opam configuration without wasting time in order to be able to work efficiently.

# Setting up your repository/ies

If we're going to work on different projects with a local opam config to these projects, we're going to create a repository for each one of these projects.

Once this is done, in each of these repositories we're going to execute this command to create a different opam *switch*:

```
opam switch create --empty .
```

As you may have guessed, an opam *switch* is an independent installation with its own compiler and sets of installed and pinned packages.

An `_opam` directory will be created in the root directory of your repository that will contain everything related to your local opam configuration.

The `--empty` option is the one that will allow you to create an opam configuration from scratch.

Now you can locally install with opam every package you need in order to work on the different repositories of your project as long as you stay in the repository or subrepositories where you executed the opam switch create.

There is one last thing to do, every time you enter a repository with a different opam switch you need to re-evaluate the opam env with this command:

```
eval $(opam env)
```
Since this can be quite annoying to do every time you switch from one project to another, an easy way to avoid this is to add in your *opam configuration* section in your `.bashrc` or `.zshrc` files either:

For **zsh**:
```
export precmd_functions
```

And for **bash**:
```
export PROMPT_COMMAND
```

And that's it. You can now work properly and efficiently without having to change manually your opam configurations every time you work on your different projects!