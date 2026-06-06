+++
title = 'Shell Programming Best Practices'
date = 2026-06-05T21:05:12-04:00
draft = false
# description = ''
# cover.image = '/posts/'
cover.hidden = true
keywords = ["bash", "shell-scripting"]
tags = ["free-software", "habits", "linux", "programming"]
ShowToc = true
+++

## My Qualifications

Since this is my own blog I'm usually happy to avoid reminding you of how
qualified I am.  In this case it is easy to note that:

- I spent a dozen years teaching shell scripting on UNIX and Linux with
  materials that I wrote the majority of.  The students were surprised and
  happy to have a teacher that had real industry experience.
- I've done [46+ code reviews for
  bash](https://codereview.stackexchange.com/users/89257/chicks) on Code Review
  StackExchange over the last decade.
- I've been a fan of `bash` and a detractor for `csh` and `ksh` for 30+ years.

## Terminology note

For purposes of this article I'm going to talk about the "shell" referring to
various shell implementations which traditionally end in "sh".  This excludes
scripting languages such as Perl and Python.  I'm not trying to say anything
bad about Python here.  There's plenty of that already on the Internet.  The
most popular shells these days are `bash`, `zsh`, and `fish`. Most of what I'm
going to say could apply to any of them, but some things will be specific to
the Bourne Shell (`/bin/sh`) and compatible shells such as `bash` and `ksh`.

## Why shell scripting endures

Shell programming has been growing in a variety of
[strange](https://github.com/edorig/dtksh) ways since it was introduced in the
1970's.  UNIX revolutionized computing by providing this interactive
environment with an amazing set of tools. The shell was where all of these
tools were brought together.  And so many shells have been developed to ease
programming and expand the possibilities.

With all of the other tools available today for handling these same tasks it is
amazing that the UNIX data processing model lives on in Linux and bash and the
vast number of command line tools that are still being actively developed.
This leads to some of the motivations that are still relevant today:

- If you need a simple wrapper around an existing command, a shell script is
  the easiest place to start.  No programming language makes it as easy to
  invoke and redirect existing commands.  You probably already have a command in
  Linux that does 90% of what you want to do.  Write a little shell script to do
  the rest.
- The shell provides a nice neutral ground between different programming
  languages.  As long as your program can handle text input or output, it can
  be integrated with other tools written in different languages.  The shell
  provides the place for integration and debugging.
- The classic UNIX toolkit is quite performant and can scale to deal with an
  incredible amount of data in a modern laptop.  Why fight with the latest
  framework for massive parallel processing when you can write a shell script to
  take care of it in less time?

And now in the age of GenAI, shell scripting has gotten another boost.  AI
coding agents are surprisingly good at writing shell scripts, and they tend to
follow best practices like strict mode without being prompted.  I've been
pleasantly surprised to see that.  But you still need to know enough to review
what the AI generates, which is where the rest of this article comes in.

## Common pitfalls

It is easy to look at a well written shell script and get lured into the idea
that shell scripting is just like programming in compiled languages.  Some of
the design choices that were made in the 1970's still affect the design of the
shell and fixes were glommed on so that it can be bewildering how to choose
when [There Is More Than One Way To Do
It](https://wiki.c2.com/?ThereIsMoreThanOneWayToDoIt).

### Line orientation

Imagine a world where you're interacting with the remote computer via a
teletype.  Each time you press *Enter* the command that you've been typing gets
processed by the computer and you get some output.  This is how the original
shells were written.  Accumulate a command and wait for the *Enter* key to
process it.  So, to this day to get a command to go across multiple lines you
need to escape the end of the line with a backslash that is immediately
followed by the newline.

### Whitespace matters

After you get in your head that everything is a line to be processed, the next
thing to add to your mental model is that the shell is going to split things up
based on whitespace.  This includes the space, tab and a few other characters.
The shell uses the whitespace to split your command up into multiple
arguments.  These arguments are passed into the command that is being run.  If
you've ever tried to run a command with a filename argument that had a space in
it, you've seen a "file not found" error or two, because the two parts of your
filename were separate arguments to the command.  Most of the time neither half
of your filename exists as a file and so you get an error message.

### Quoting

To overcome the shell splitting your filename, you have a variety of choices:

- Put it in single quotes (`'`) and the shell will leave it alone
- Put it in double quotes (`"`) and the shell will probably leave it alone
- Put a backslash (`\`) in front of the space to escape it.

Single quotes are simple: they escape everything inside of them.  No shell
magic works inside of single quotes.  What you put in them should get passed to
the command without alteration.  Double quotes are more interesting and
complex.  Double quotes allow some shell magic to occur.  The most important
thing that you can do inside of double quotes is variable substitution, which I
will cover in the next section.

### Variable substitution

Substitution is shell terminology for putting the value of a variable somewhere
in your command.  The dollar sign (`$`) is how a substitution starts in the
shell.  If a dollar sign is followed by a word like `foo`, you are substituting
the value of `foo` in that spot.  So `ls $foo` will change depending on the
variable `foo`.  The variable `foo` is probably a directory or file name in the
context of running `ls`.  But it could also contain options.  If `foo` contains
options and a file name they would be separated by spaces in the variable. Then
the shell will substitute that variable, see the spaces and split it up into
multiple arguments for the `ls` command.  That sounds great in this example,
but typically that is not a desirable behavior.  The best practice for variable
substitution is to encapsulate it in double quotes so that the substitution can
work, but the whitespace does not cause it to be split into multiple
arguments.  Prefer `"$foo"` over `$foo`.

### Command substitution

Beyond variable substitution, the shell can substitute the output of an entire
command.  This is called command substitution and it comes in two flavors:

- Backticks: `` `command` ``
- Dollar-paren: `$(command)`

Both do the same thing: run the command and substitute its output in place.  But
the dollar-paren form is strongly preferred for several reasons:

1. Nesting works naturally.  `` `echo \`echo hello\`` `` is a mess of escaping,
   while `$(echo $(echo hello))` reads clearly.
2. It's visually distinct from single quotes, which backticks resemble
   in many fonts.
3. It composes with variable substitution naturally: `"/data/$(date +%Y)"`.

If you see backticks in a script, it works, but it's a habit worth upgrading.

## Best practices

Now that we've covered the pitfalls that trip people up, let's talk about
habits that make shell scripts significantly more reliable and maintainable.

### Shebang lines

Every shell script should start with a shebang line that tells the system which
interpreter to use.  This is so fundamental that shellcheck will warn you when
it's missing.

The two common approaches are:

```bash
#!/bin/bash
```

and:

```bash
#!/usr/bin/env bash
```

The first is explicit and unambiguous about which bash binary to run.  The
second uses `env` to find bash on the `PATH`, which is more portable across
different systems.  The `env` approach is what I prefer because it handles the
case where bash lives in different places on different operating systems.  Either
way, pick one and use it consistently.

For scripts that only use POSIX features, you can even use:

```bash
#!/bin/sh
```

which ensures maximum portability but limits you to Bourne shell features.

### Shell strict mode

As [Aaron Maxwell explains so
well](http://redsymbol.net/articles/unofficial-bash-strict-mode/) so many years
ago, it is a good habit to start your shell scripts with:

```bash
set -euo pipefail
IFS=$'\n\t'
```

This is akin to Perl and JavaScript's strict modes.  It makes shell scripting
less surprising.  Breaking it down, here is what it changes:

1. `set -e` — Exits immediately on any command failure, making errors explicit
   and loud instead of silently continuing (where a failed mid-script command
   could be masked by a successful final command).
2. `set -u` — Catches undefined variable references (e.g., typos like $firstname
   vs $firstName), immediately failing instead of silently evaluating to an
   empty string.
3. `set -o pipefail` — Prevents pipeline errors from being masked. Without it, a
   failing command in a pipeline (like grep on a nonexistent file piped to
   sort) returns the exit code of the last command (0), hiding the error. With
   pipefail, the pipeline returns the failing command's exit code.
4. `IFS=$'\n\t'` — Removes space from the field separator, so word splitting
   only happens on newlines and tabs. This prevents filenames and strings with
   spaces from being split unexpectedly—essential for correctly iterating over
   arrays or handling arguments with spaces.

This has been such a widely recognized paradigm that it is now baked into
Claude Code and other coding agents.  Seeing the AIs generating code with
strict mode was a very pleasant surprise for me.

The only part that I've found to occasionally be inconvenient is the `set -o
pipefail` but that is pretty rare and not hard to work around.  Worst case is to
wrap a challenging pipeline with `set +o pipefail` around the problematic line
then `set -o pipefail`.

One important caveat about `set -e`: it does not trigger inside `if` conditions,
`while` loops, or commands connected with `&&` or `||`.  This is by design—the
shell assumes you're already handling the error in those contexts.  But it means
that `set -e` is not a complete substitute for explicit error checking.  It
catches the obvious failures and makes your scripts safer, but you still need to
think about error handling for the cases where it silently steps aside.

### Conditionals

One of my pet pieces in shell script is single bracket conditionals.  For
instance, I just plucked this from my own code:

```bash
if [ -f /etc/bashrc ]; then
```

Luckily that is code from 2013, but I'm still sad that I wasn't in the good habit of writing it like this:

```bash
if [[ -f /etc/bashrc ]]; then
```

Not that much difference!  Just double brackets instead of single brackets.
Would it make any difference?  In the case of this conditional, no, either one
should work fine for this conditional.  But what about:

```bash
if [[ -f "$filename" ]]; then
```

Where we have a variable that should contain a filename.  But what if we
accidentally end up with nothing in $filename?  Since we're following best
practices, nothing weird happens.

1. Our double quotes don't care that $filename is empty.  Empty double quotes
   still count as an argument in the UNIX command line sense, so `-f` still gets
   an argument and something to look for.  And the double brackets also protect
   us.
2. If we left out the quotes, the double square brackets make an exception to
   the normal command line parsing rules and preserve the part that became
   empty as an argument.

### Parameter expansion

Shell variables have a built-in superpower that most people never fully
explore: parameter expansion.  Beyond simple substitution, the shell gives you
concise ways to handle default values, assign fallbacks, and manipulate strings.

Some of the most useful forms:

- `${var:-default}` — Use `default` if `var` is unset or empty
- `${var:=default}` — Assign `default` to `var` if it's unset or empty
- `${var:+alternate}` — Use `alternate` if `var` is set (the opposite of `:-`)
- `${var#pattern}` — Remove shortest match of `pattern` from the start
- `${var##pattern}` — Remove longest match of `pattern` from the start
- `${var%pattern}` — Remove shortest match of `pattern` from the end
- `${var%%pattern}` — Remove longest match of `pattern` from the end

The `:-` forms are invaluable for script robustness.  Instead of writing:

```bash
if [ -z "$OUTPUT_DIR" ]; then
    OUTPUT_DIR=/tmp
fi
```

You can write:

```bash
OUTPUT_DIR="${OUTPUT_DIR:-/tmp}"
```

The `#` and `%` forms are handy for filename manipulation.  Need the file
extension?  `${filename##*.}` gives you everything after the last dot.  Need the
name without the extension?  `${filename%.*}` strips the shortest match from the
end.  If you're reaching for `sed` or `awk` to do simple string extraction,
check whether parameter expansion can handle it first.

### Checking return values

Sometimes you will see code which runs a command and then looks at `$?` to see if
it was successful.  But there is a much simpler way to code this in the shell:

```bash
if cmd; then
        # it succeeded
else
        # it failed
fi
```

Just drop the brackets and put your command after the if.  Unless you care
about particular return values, this will be much cleaner to write and be less
fragile to maintain.

### Functions

Shell scripts beyond a few lines benefit from functions.  They make your code
more readable, more testable, and avoid the dreaded "spaghetti script" that
grows by accretion.

A few key points about shell functions:

- The `function` keyword is optional in bash.  `my_func() { ... }` and
  `function my_func() { ... }` both work.  Pick one style and stick with it.
- Shell functions don't declare parameters explicitly.  Inside a function,
  `$1`, `$2`, etc. refer to the arguments passed to the function, not the
  script.
- Always use `local` for variables that shouldn't escape the function.  Without
  it, you're polluting the global namespace and creating bugs that are
  surprisingly hard to track down.

```bash
count_files() {
    local dir="${1:-.}"
    local count
    count=$(find "$dir" -maxdepth 1 -type f | wc -l)
    echo "$count"
}
```

We'll see a concrete example of this in the Shellcheck section below,
where shellcheck flags an alias trying to use positional parameters.  The fix is exactly
what shellcheck suggested: use a function instead.

### Cleanup with trap

One of the most underused features in shell scripting is `trap`.  It lets you
register code that runs when the script exits, whether normally or from a
signal like Ctrl-C.  This is essential for cleaning up temporary files,
releasing locks, and restoring terminal settings.

A common pattern:

```bash
cleanup() {
    rm -f "$tmpfile"
}
trap cleanup EXIT

tmpfile="$(mktemp)"
```

No matter how your script exits—successfully, with an error, or from an
interrupt signal—the `cleanup` function will run and remove the temporary file.
This pairs naturally with `set -e`: since strict mode causes your script to exit
on the first error, you need `trap` to ensure cleanup happens even on unexpected
exits.

You can also trap specific signals separately if you need different behavior
for Ctrl-C versus normal exit:

```bash
trap 'echo aborted; exit 1' INT
trap cleanup EXIT
```

### When not to use shell

I've been advocating for shell scripting throughout this article, but it's
important to know its limits.  Shell scripting is the wrong tool when:

- You need complex data structures beyond simple arrays and associative arrays.
  If you're simulating a hash map of lists, it's time for Python.
- You're doing math beyond simple integer arithmetic.  Shell math is limited and
  awkward.  `$((1 + 2))` works for integers, but anything involving floating
  point means you're shelling out to `bc` or `awk` and you've lost the
  simplicity advantage.
- You need proper error handling with exceptions.  Shell error handling is
  pragmatic but crude compared to try/catch in most languages.
- Your script is growing past a few hundred lines.  At that point the lack of
  modules, proper scoping, and a type system makes maintenance harder than it
  needs to be.
- You're handling passwords or other secrets on the command line.  Arguments to
  shell commands are visible in `ps` output, which is a security nightmare.

The rule of thumb I've always used: if you're writing more functions than
pipelines, you've probably crossed the threshold where a full programming
language would serve you better.

## Useful resources

Here are a few resources that you will find handy while shell scripting.

### Shellcheck

Shellcheck is the premier linter for shell scripts.  It is embedded in a
variety of other tools like the Super-Linter and ActionLint GitHub actions.
This should be one of the first things you download in your shell scripting
journey.  It might initially be a bit intimidating to see the results on your
code, but over time your habits will get used to shellcheck's complaints and
you won't hear from it quite as often.  Another brief example from my old code:

```text
❯ shellcheck .aliases

In .aliases line 1:
alias grep='grep --colour=auto'
^-- SC2148 (error): Tips depend on target shell and yours is unknown. Add a shebang or a 'shell' directive.

In .aliases line 4:
alias greattail='goodtail $1 | /home/chicks/colorlog2'
      ^-- SC2142 (error): Aliases can't use positional parameters. Use a function.

For more information:
  https://www.shellcheck.net/wiki/SC2142 -- Aliases can't use positional para...
  https://www.shellcheck.net/wiki/SC2148 -- Tips depend on target shell and y...
```

Shellcheck makes two useful points:

1. There's no shebang line so it doesn't know which shell to target.  I'm
   definitely a fan of good shebang lines, but I have skipped it for this file.
2. Line 4 tries to do something with an alias that will probably fail.  Doh.

Shellcheck is packed with useful hints.  It will teach you or your AI a lot
about writing good shell scripts.

### Google's Shell Style Guide

Another great influence on shell best practices is Google's [Shell Style
Guide](https://google.github.io/styleguide/shellguide.html). If you like the
advice in this blog post, then you'll want to make this your next reading
assignment.  I don't even see anything to quibble over in it.  It is a lot of
sound advice on shell best practices.

## Conclusion

Shell scripting occupies a unique niche: it's been around for over fifty years,
it's available on every UNIX-like system, and it's still the most natural way to
glue commands together.  The pitfalls are real—whitespace sensitivity, quoting
rules, and silent error handling have frustrated generations of programmers—but
the best practices to avoid those pitfalls are well-established and straightforward.

Start with strict mode.  Quote your variables.  Use double brackets.  Write
functions with `local` variables.  Clean up with `trap`.  Run shellcheck.  Follow
these habits and your shell scripts will be more reliable than you might have
thought possible.

And if you find yourself reaching for arrays of arrays or floating-point math,
it's okay.  That's Python's job.  The shell will still be there when you need to
pipe its output somewhere useful.
