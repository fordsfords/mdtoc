# mdtoc

Yet another markdown toc generator.

## Table of Contents
<!-- toc-start -->
&DoubleRightArrow; [mdtoc](#mdtoc)  
&nbsp;&nbsp;&DoubleRightArrow; [Table of Contents](#table-of-contents)  
&nbsp;&nbsp;&DoubleRightArrow; [Introduction](#introduction)  
&nbsp;&nbsp;&DoubleRightArrow; [Why Another?](#why-another)  
&nbsp;&nbsp;&DoubleRightArrow; [License](#license)  
<!-- TOC created by './mdtoc.pl README.md' (see https://github.com/fordsfords/mdtoc) -->
<!-- toc-end -->

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

Then run the tool:
````
./mdtoc.pl README.md
````

This directly modifies README.md, adding the TOC. It also 
creates

## Design Notes

The tool will react to only the first instance of `<!-- mdtoc-start -->`
it encounters in the file; any subsequent instances will be simply passed
as content.

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
