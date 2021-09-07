kiru.gay
--------

My website is right inside `src/` and is then generated with the help of
`build.sh` and `Makefile` to run the script.

ksg
---

Standing for kiru(s)-site-generator, it is what powers the whole thing
and turns all the Markdown and everything from `src/` into a proper
website inside `build/` it can be installed as a standalone program with
`make install`, ksg itself is still in major development specifically
the blog post portion of it. However you're free to still use it.  With
it installed you can use it to generate your own website. Like so:

```sh
$ ksg <title>
```

Where `<title>` will be the title of the pages. Individual page titles
are yet to be supported.

### Format

As for the format it's quite simple, in the base of your folder you'll
have Markdown files like `index.md` which will be translated to
`index.html` you can then use `%%<file>%%` anywhere to import the
contents of a file inside `src/resources/` like a `footer.html` or
something similar.

However `header.html`, `footer.html` and `navbar.html` are all files
required, as they're imported when the Markdown gets translated to HTML.

You can also import the output of a command with `||<command>||` aka
`||date||` will turn into the output of the `date` command.

### Settings

`ksg` also supports a few settings. Such as changing the destination
folder and or the site folder and so on. They're all done in the form of
environment variables. You can set the variables however you like, as an
example `TITLE="Test" ksg`

Below are all the available settings, more will be added later on...

```sh
$SITE    default: src
$DEST    default: build
$TITLE   default: Title
```
