# mdtoc

Yet another markdown toc generator.

## Table of Contents
<!-- mdtoc-start -->
&DoubleRightArrow; [mdtoc](#mdtoc)  
&nbsp;&nbsp;&DoubleRightArrow; [Table of Contents](#table-of-contents)  
&nbsp;&nbsp;&DoubleRightArrow; [Introduction](#introduction)  
&nbsp;&nbsp;&nbsp;&nbsp;&DoubleRightArrow; [Dependencies](#dependencies)  
&nbsp;&nbsp;&nbsp;&nbsp;&DoubleRightArrow; [Disclaimer](#disclaimer)  
&nbsp;&nbsp;&DoubleRightArrow; [Usage](#usage)  
&nbsp;&nbsp;&nbsp;&nbsp;&DoubleRightArrow; [Examples](#examples)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&DoubleRightArrow; [Example 1](#example-1)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&DoubleRightArrow; [Example 2](#example-2)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&DoubleRightArrow; [Example 3](#example-3)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&DoubleRightArrow; [Example 4](#example-4)  
&nbsp;&nbsp;&DoubleRightArrow; [Design Notes](#design-notes)  
&nbsp;&nbsp;&DoubleRightArrow; [Why Another?](#why-another)  
&nbsp;&nbsp;&DoubleRightArrow; [License](#license)  
<!-- TOC created by './mdtoc.pl README.md' (see https://github.com/fordsfords/mdtoc) -->
<!-- mdtoc-end -->

## Introduction

I, like very many other people, like my documents to have a table of contents.
For web-based documents, clickable links make navigation easier and faster.
But GitHub flavored markdown has no automated table-of-contents generator.
This tool fills that gap.

### Dependencies

* Perl

### Disclaimer

I'm not a markdown expert.
I did enough experimenting with how various header texts are converted to
HTML references that I think I know the algorithem.
But there may be corner cases that I don't know.
This would result in the links not working right.

Let me know if you have a broken test case.

## Usage

Here's the tool's built-in help (obtained by running it with
the '-h' option):
````
Usage: mdtoc [-h] [-b backup_suffix] [file ...]
    -h - help
    -b backup_suffix - File name suffix for backup file.
       Use '-b ""' for no backup. Defaults to '-b ".bak"'.
    file ... - one or more input files.  If omitted, inputs from stdin.
````

Many of my repos have a build script or maybe a test script in which I include the following:
````
# Update doc table of contents (see https://github.com/fordsfords/mdtoc).
if which mdtoc.pl >/dev/null; then mdtoc.pl -b "" README.md;
elif [ -x ../mdtoc/mdtoc.pl ]; then ../mdtoc/mdtoc.pl -b "" README.md;
else echo "FYI: mdtoc.pl not found; see https://github.com/fordsfords/mdtoc"
fi
````

This first checks to see if mdtoc.pl is in the PATH and runs it.
If not, it checks to see if mdtoc repo exists in the parent directory,
and runs it.


### Examples

I typically do my markdown documentation work using a simple text editor
at a Unix (or Unix-like) shell prompt.
I'm pretty confident that this tool will also work on Windows at a command
prompt.
But I'll show my usage.

First, insert the following in your .md file:
````
<!-- mdtoc-start -->
<!-- mdtoc-end -->
````
This shows the tool where to insert the TOC.

#### Example 1

````
./mdtoc.pl README.md
````

This directly modifies "README.md", adding the TOC. It also 
creates a backup file, "README.md.bak", which saves the contents
of "README.md" before the tool modifies it.

#### Example 2

````
./mdtoc.pl <README.md >README.new
````

This does not modify "README.md",
and does not create a backup file.
It reads the "README.md" file and writes the modified version
to "README.new".

#### Example 3

````
./mdtoc.pl -b "~" *.md
````

This finds all the ".md" files in the current directory and
modifies them, naming the backup files with the `"~"` suffix.
E.g. "README.md~"

#### Example 4

````
find . -name '*.md' -print0 | xargs -0 ./mdtoc.pl -b ""
````

This finds all ".md" files in the current directory and
all sub-directories recursively.
Setting the backup suffix to the empty string causes no backup
file to be created.

Note the use of "print0" and "-0"; this handles file names that
contain spaces (something we Unix old-timers tend to forget about).

## Design Notes

* This tool uses the Perl "diamond" operator.
See https://blog.geeky-boy.com/2020/07/perl-diamond-operator.html#Security_Warning
for a security warning about it.

* If this tool is processing multiple files and one of them has
an error, the tool stops processing immediately.
The current file (with the error) is not modified and
no subsequent files are processed.

* The tool will react to only the first instance of `<!-- mdtoc-start -->`
it encounters in the file; any subsequent instances will be simply passed
as content.

* I didn't use lists, like most similar tools use. Why not?

  There can be syntactically-valid .md files that don't follow the
normal (intuitive) sequence of header levels.  For example:
  ````
  ### First header
  blah
  ## Second header
  blah
  #### Third header
  blah
  ````

  Trying to use normal markdown list syntax just doesn't work well.
Go ahead - try it with other markdown TOC tools.

* The "tst.sh" script is a self-test that includes running several .md
files through GitHub's rendering API and makes sure the TOC links are
the same as the HTML href tags.

## Why Another?

Really? Seriously?
There are lots of markdown TOC tools out there.
Why did we need another one?

I used https://luciopaiva.com/markdown-toc/ but didn't
like the cut-and-paste.

I tried https://github.com/ekalinin/github-markdown-toc
but didn't like the dependency on curl and didn't love
the code either.
I'm sure there's another one out there that I would like,
but what the heck -- I like to code.

## License

I want there to be NO barriers to using this code, so I am releasing it to the public domain.  But "public domain" does not have an internationally agreed upon definition, so I use CC0:

Copyright 2020 Steven Ford http://geeky-boy.com and licensed
"public domain" style under
[CC0](http://creativecommons.org/publicdomain/zero/1.0/):
![CC0](https://licensebuttons.net/p/zero/1.0/88x31.png "CC0")

To the extent possible under law, the contributors to this project have
waived all copyright and related or neighboring rights to this work.
In other words, you can use this code for any purpose without any
restrictions.  This work is published from: United States.  The project home
is https://github.com/fordsfords/mdtoc

To contact me, Steve Ford, project owner, you can find my email address
at http://geeky-boy.com.  Can't see it?  Keep looking.
