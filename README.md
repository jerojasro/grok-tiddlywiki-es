# extraction of plugin tiddlers

Get the plugin file that contains all the book contents. In the current repo,
that's the `GrokTiddlyWiki.json` file.

Process that file to extract all the tiddlers part of the plugin as individual
files, and to mark each translatable string in those files as such:

```
python tw.py GrokTiddlyWiki.json
```

that will create one file per each tiddler in the plugin, in the `tiddlers_en`
directory.

# arch. decisions

in the book, tiddler titles are used as human/semantic titles, but also as IDs
of tiddlers; this is problematic because

  * The titles are used in the text of other tiddlers, for transclusions/etc.
    Because of this, we should *not* change them.
  * The titles are shown to the person reading the book. Because of this, we
    *should* change (translate) them.

So, to resolve this, I will:

  * Leave the titles alone, to spare me the hassle of chasing tiddler titles in
    other tiddlers.
  * Copy titles to a `human_title` field, meant to be shown to humans; I'll
    translate that one.
  * Adjust the tiddlywiki templates in the translated version of the book, to
    use the human title in places where humans will see them.

# Notas para traductores

El lector/a es «usted»; no lo tutee.

Traducciones usuales:

  * dollar sign: signo de peso
  * takeaways: para recordar
  * journal: bitácora
  * meeting notes: minutas
  * saver: mecanismo de guardado
  * cambie las comillas dobles (\\u201c: “ y \\u201d ”) por comillas francesas:
    «», cuando las vea en alguna frase.

# about po4a and the custom TiddlyWiki parser

This translation project uses po4a (PO for Anything) to manage the translation
pipeline. There is a custom bit which we had to add in order to support
TiddlyWiki/GTW: the code required for checking each tiddler, and extracting the
translatable strings: that resides in the `Tiddlywiki.pm` file in this repo.

To let po4a use it, copy `Tiddlywiki.pm` to the directory where po4a searches
for its parsers; in a Debian system, this is `/usr/share/perl5/Locale/Po4a/`.
