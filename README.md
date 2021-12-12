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

### Blogging

Currently you can't just disable blog posts, so if you don't want it
just don't have it in your footer or header, but blog.html will always
be created.

As far how the posts work, you simply add a Markdown file (.md) in
`src/posts` it'll then be auto converted and placed in `build/blog`, as
for how to name them, they support upper case characters, and the links
will be auto converted to lowercase so that the links don't look stupid,
you can also use spaces, it'll convert that to -'s, and to sort them
properly add a number in the file name. Example below:

```sh
1 A long title.md # this will come out as "a-long-title.html"
2 An even longer title.md # this will be put above the previous one
0 A short title.md # this will be put first
```

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
