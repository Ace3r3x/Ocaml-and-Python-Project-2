# Coursework 2

This is the repository with the stubs of the implementation for
Coursework 2 in F28PL. In order to submit the coursework, you will
need to *fork* this repository, creating your own, private version on
GitLab, clone your fork onto your local machine, create your solution
within your repository and push the solutions to your own fork of the
project.

## Getting started

The first steps to get you to the point of being able to create your
own solution are as follows:

1. Fork the project. To do this, find the "Fork" button in the
   top-right of the project's web-page, click it, and follow the
   instructions. Remember to set your fork as private (the markers
   should be added to your project automatically, so you do not need
   to worry about their access).

2. Clone your fork to create an image of the repository on your local
   machine, attached to your fork. To do this, you will need a working
   `git` installation. (Note: if you're developing the coursework
   under WSL, your working `git` installation should also be on
   WSL. You should be able to get `git` working on your Linux
   subsystem using something like `sudo apt-get install git`.)

3. Develop your coursework. At this point, you can start developing
   your coursework. To avoid data loss, it is wise to periodically
   *commit* your changes to your local repository, and *push* them to
   your fork. (This will also allow you to work across multiple
   machines if, for instance, you have both a laptop and desktop
   computers.)

4. Remember to push your the solution of the coursework problems to
   your fork of the project *before the deadline*!

## Developing your project

Once you clone the repository, you may notice that there are quite a
few files. Some of them are provided to make the development and
testing process more streamlined, and you shouldn't need to worry
about them too much. The most important part, the solution files, live
in the `src` subdirectory of the project, and that is where you should
keep them. The source files are called `question1.ml`, `question2.ml`,
`question3.py`, and `question4.py` respectively, and provide templates
for the solution of each question. The files are self-contained, so
you should be able to work on the solutions using an editor and an
evaluator, as usual. Make sure to provide both the implementation and
explanations that detail how your code should work, and why you
designed it the way you did, as well as answers to questions that do
not require coding.

The `.mli` files present in the `src` subdirectory are there to ensure
that the types of your definitions match the specification when you
compile the project. You should not modify these under any
circumstances.

The project is equipped with automated compilation and testing
features. You don't need to worry about these too much; if you want to
use them, running `dune build` in the top-level directory of the
project will compile the project, and `dune runtest` will run your
tests. A couple of unit tests have been provided for Question 1 in
this coursework. If you would like to add tests of your own, you can
do so by defining `QCheck` tests in the `test/testCw2.ml` file, and
adding those to the list of tests for the appropriate question. In
case of difficulties, ask one of us for help! Running `dune build` on
the freshly forked version of the project, you might see a bunch of
warnings: these would signal that parameters of the functions that you
are to define are not used --- and thus should start to go away as you
implement your solutions. Pushing the project to your fork will
automatically compile it and run the tests, but of course you can also
do this locally on your machine.
