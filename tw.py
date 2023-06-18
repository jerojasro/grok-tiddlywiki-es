import argparse
import json
import re

from pathlib import Path


def generate_book_plugin(tiddlers_dir: str, orig_plugin_file: str):
    with open(orig_plugin_file) as pf:
        plugins = json.load(pf)
    plugin = plugins[0]
    tiddlers = json.loads(plugin["text"])

    for translated_tiddler in Path(tiddlers_dir).glob("*.json"):
        tiddler = json.load(translated_tiddler.open())
        tiddlers['tiddlers'][tiddler["title"]] = tiddler
        print('added ' + tiddler["title"])

    plugin["text"] = json.dumps(tiddlers)
    plugin["version"] = "1.2.3"
    with open("translatedGTW.json", "w") as tpf:
        json.dump(plugins, tpf)


def fs_sanitize(filename_raw: str):
    return re.sub("[^a-zA-Z0-9$,?_.: -]", "_", filename_raw)


def extract_plugin_tiddlers(plugin_text: str):
    plugin = json.loads(plugin_text)[0]
    plugin_tiddlers = json.loads(plugin["text"])["tiddlers"]

    target_dir = Path.cwd() / "tiddlers_en"

    seen_tiddlerfns = set()

    for title, tiddler in plugin_tiddlers.items():
        tiddler["human_title"] = tiddler["title"]
        fn = fs_sanitize(title) + ".json"
        if fn in seen_tiddlerfns:
            assert False, f"{fn} is duplicated"
        seen_tiddlerfns.add(fn)
        with open(target_dir / fn, "w") as tf:
            tf.write(json.dumps(tiddler, indent=2))


EXTRACT_CMD = "extract"
GENPLUGIN_CMD = "genplugin"


def main():
    parser = argparse.ArgumentParser()
    subp = parser.add_subparsers(required=True, dest="command")
    parser_extract = subp.add_parser(EXTRACT_CMD)
    parser_extract.add_argument("plugin_file")
    parser_genplugin = subp.add_parser(GENPLUGIN_CMD)
    parser_genplugin.add_argument("tiddlers_dir")
    parser_genplugin.add_argument("original_plugin_file")

    args = parser.parse_args()
    if args.command == EXTRACT_CMD:
        extract_plugin_tiddlers(open(args.plugin_file).read())

    if args.command == GENPLUGIN_CMD:
        generate_book_plugin(
            tiddlers_dir=args.tiddlers_dir, orig_plugin_file=args.original_plugin_file
        )


if __name__ == "__main__":
    main()
