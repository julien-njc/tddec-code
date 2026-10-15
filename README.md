tddec-code
==========

Book code for Test-Driven Development for Embedded C

This directory structure is not exactly the same as the structure
of the code in Test-Driven Development for Embedded C.  I flattened
the structure so that there are no projects inside of projects.

#### Instructions for building the book's code with Docker

With the ever changing C/C++ environments, it has been a challenge to keep
the TDD-EC code building.  To make it easy to get started I'm using
Docker to take out the guess work.

A cool thing about using Docker is that you don't have to install other 
compilers on your system, though you do have to install docker.  The
compilers and tools are hidden in the docker container.

####  Install Docker
I use a Mac, so I've installed docker for Mac. It was easy.  I expect the 
Linux install to also be easy.  For Windows you can either use the newer Docker
for Windows, if you have Hyper-V, or the older VirtualBox based Docker Toolbox.
Ideally you should use 64-bit Windows. (If you get this
workig with Windows and Docker, please contribute your instructions.)

You might be thinking, why should I go to all this trouble?  You should 
because it's not that much trouble and then you will have a great unit test 
environment that does not interfere with your native environment.

If you do find differences or errors please let me know.  

[Docker Install Information](https://docs.docker.com/engine/installation/)

#### Clone the tddec-code repo

```
git clone https://github.com/jwgrenning/tddec-code.git
cd tddec-code
```

CppUTest is built into the Docker image, so there's nothing else to download.

#### Build and run all the tests

The same commands work on Mac, Linux and Windows (cmd.exe or PowerShell), as long
as Docker is running. Run them from the `tddec-code` directory.

```
docker compose run --rm tddec
```

The first run builds the `tddec/cpputest` image (gcc 16 + CppUTest v4.0) from the
`Dockerfile`, then builds the TDD-EC book code and runs its tests. Later runs
reuse the image.

The `tddec-code` directory is mounted in the container at `/usr/src/tddec-code`,
so edits you make on your machine are visible in the container right away.

#### Build any sub-project from a command line

Open a bash shell in the container:

```
docker compose run --rm tddec bash
```

From the container bash prompt, go to any subdirectory like this:

```
cd code-t2
make
```

You can also do it in one command:

```
docker compose run --rm tddec make -C code-t2
```

You can now play to your hearts content and use this setup to bootstrap your own
test environment. You can make changes to the `code-t2` files,
flip over to the Docker command line and run make.

If you change the `Dockerfile`, rebuild the image with `docker compose build`.

#### gcc 16 and CppUTest v4.0

The Docker image uses gcc 16 (Debian trixie) and CppUTest v4.0, and includes `gdb`.
The book was written for older compilers, which no longer get maintained images, so
these changes keep the code building with no warnings while `-Werror` stays on:

* **Pinned language standards.** gcc 16 compiles C as C23 and C++ as C++17 by default.
  In C23, `void f();` means `void f(void);`, which breaks some of the code.
  `CppUTestCompileFlags.mk` adds `-std=gnu99` (C) and `-std=gnu++11` (C++), and
  `code/MakefileUnity.mk` and `SandBox/MakefileUnity.mk` add `-std=gnu99`
  to the Unity builds.
* **One new warning off.** `-Wno-enum-int-mismatch` (added in gcc 13) is turned off.
  The `LightScheduler` headers declare `int day` while the source uses `Day day`. Every
  other warning flag is unchanged.
* **Semicolons after CppUTest assertions.** CppUTest v4.0 assertion macros are wrapped in
  `do { ... } while (0)`, so they need a trailing `;`. The `checkLightState()` helpers in
  `code-t1`, `code-t2` and `code-t3` (`tests/HomeAutomation/LightScheduler*Test.cpp`)
  now use braces and semicolons.
* **No CppUTest submodule.** The repo no longer includes CppUTest as a git submodule.
  The top-level `Makefile` uses whatever `CPPUTEST_HOME` points at, and stops with an
  error if it isn't set. `make clean` only cleans the book code.

Known issue: one of CppUTest v4.0's own tests,
`MemoryLeakWarningThreadSafe.turnOnThreadSafeNewDeleteOverloads`, fails while the image
builds. It doesn't stop the build and doesn't affect the book code.

---
---
---

### If you want to try without docker, you might run into the problem of
moving targets for CppUTest, gcc and clang.
---
---
---

The CppUTest install has changed a lot since my book was written.  So you'll have 
to install CppUTest locally for use with the book code.

1) Download CppUTest v4.0 from cpputest.org (older versions don't compile with
recent gcc). Put CppUTest somewhere like
    `~/tools/cpputest`

2) Build CppUTest locally using these instructions not the instructions 
from cpputest.org.

```
cd ~/tools/cpputest
autoreconf . -i
./configure
make tdd
```

3) Define an environment variable to point to where you put CppUTest, like

```
export CPPUTEST_HOME=~/tools/cpputest
```

Under Windows you can use the control panel or `setx` utility to set the
environment variable.  Make sure to restart your IDE, or terminal window.

4) Unzip the code into some directory /path/to/code/root. Make sure the path contains no spaces.
You should end up with this directory structure:

```
    /path/to/code/root/code
    /path/to/code/root/code-t0
    /path/to/code/root/code-t1
    /path/to/code/root/code-t2
    /path/to/code/root/code-t3
    /path/to/code/root/SandBox
```

5) Build the examples

```
% cd /path/to/code/root
% make
```

To do a clean build

```
% cd /path/to/code/root
% make clean all
```

To make a specific project from the command line (code-t0 for example)

```
cd /path/to/code/root/code-t0
make
```

### Warning problems with gcc/clang

With the compilers adding more and more static analysis, each compiler may issue warnings like this:

```
#undef __USE_MINGW_ANSI_STDIO
       ^
/path/to/tools/cpputest-3.8/include/CppUTest/CppUTestConfig.h:265:9: error: macro name
      is a reserved identifier [-Werror,-Wreserved-id-macro]
#define __USE_MINGW_ANSI_STDIO 1
        ^
In file included from <built-in>:1:
/path/to//tools/cpputest-3.8/include/CppUTest/MemoryLeakDetectorNewMacros.h:58:9: error: 
      keyword is hidden by macro definition [-Werror,-Wkeyword-macro]
#define new new(__FILE__, __LINE__)
        ^

```

The `-Werror` flag tells the compiler to treat warning as errors, causing the compile to fail.  You could turn that off, but before you do that, you can tell the compiler to not complain about specific errors.  

For the two errors shown in the above error output, from the (cygwin, mongx, linux, mac) command line set the initial value for `CPPUTEST_WARNINGFLAGS` like this:

```
export CPPUTEST_WARNINGFLAGS="-Wno-reserved-id-macro -Wno-keyword-macro"

```

Notice that adding "no-" to the warning flags from the error output disables that warning.  Generally this can be used to disable any new warning that comes up.

Run make again.  Once you clear the warnings you should get a clean build. You could add any of your needed compiler flag setting to `CppUTestCompileFlags.mk`.

### Unknown warnings in gcc/clang

If your compiler does not support some warning flag in the released makefiles, you can get an error about it.  The `-Wno-unknown-warning-option` is in `CppUTestCompileFlags.mk`, but may not be supported.  You'll need to comment out each flag the compiler complains about in `CppUTestCompileFlags.mk`.

-----------------
For eclipse users
-----------------
You should be able to import the whole directory tree as a project.  Make sure to use the options for a makefile project.   You do not want eclipse managing this unit test build for you.

-----------------------
For Visual Studio users
-----------------------
The ".dsp" and ".dsw" files provided for Visual Studio version 6 are likely out of date. VisualStudio usually can upgrade those.  If not and you are knowledgeable about VS you should be able to get the code to build without a lot of trouble.

You'll want to first build CppUTest and then define CPPUTEST_HOME in your environment variables.  VS must be restarted for it to see CPPUTEST_HOME.  You may have to adjust how the book code test projects reference the library holding CppUTest.  Get code-t0 to work first, then the others will be easier.

If you want to make Visual Studio support files for all the projects, please fork the repo make the changes and send me a pull request.

6) Reading the code

-------------
For everybody
-------------
When you look at the downloaded code, you will see some distracting comments throughout the code
that look like this:

    /* START: codeIncludeTag */
    ...
    ... code ...
    ...
    /* END: codeIncludeTag */

These allow the code to be kept separate from the book text. This keeps the examples compilable
and avoids book/code conflicts.  The "START: codeIncludeTag" and "END: codeIncludeTag"
tags identify code that is pulled into the book during the automated book build process. 
Try to ignore them.

You will also notice some code that has been turned off using conditional compilation. 
It looks like this:

    #if 0 /* START: IsOnTake1 */
    BOOL LedDriver_IsOn(int ledNumber)
    {
        return TRUE;
    }
    #endif /* END: IsOnTake1 */

Code in the #if 0 block is a snapshot of code that has since evolved. It may or may 
not have code include tags.  In this book, the code is always evolving.  I've left 
the latest version at the top of the file and move the intermediate code snippets 
further down the file.    

7) Experiment

-----------------
SandBox - project
-----------------

Here is a project ready for you to experiment with CppUTest any my version of Unity

--------------------------
About Unity test framework
--------------------------

The version in the book is not the supported version maintained by the guys at
throwtheswitch.com.  If you want a supported version, please go to throwtheswitch.com


Please report any problems on the book's forum: www.pragprog.com/titles/jgade.


