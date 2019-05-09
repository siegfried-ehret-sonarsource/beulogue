# `beulogue`

> `beulogue` [\bøloɡ\]: french for blog.

## Installation

### Download binaries

TODO

### Build from source

- Clone this repository.
- Install [Crystal](https://crystal-lang.org/) and [Shards](https://github.com/crystal-lang/shards).
- Run `make install` then `make`.
- The `beulogue` binary will be in the `bin/` folder.

## Usage

### Structure

Your website must be something like:

```
my-website
├── beulogue.yml
├── content
│   ├── 2019
│   │   ├── 05
│   │   │   └── may.md
│   │   └── jtutu.md
│   ├── about.fr.md
│   ├── about.jp.md
│   └── about.md
└── templates
    ├── list.html
    └── page.html
```

- `beulogue.yml` is a mandatory configuration file
- `content/` is the folder with all your pages

### Configuration

The possible keys and values are:

- **title** (string): the title of your website.
- **languages** (array of strings): the list of languages for the website. The first one is the default one.

Example:

```yaml
title: My site
languages:
  - en
  - fr
```

### Content

Content items must be in the `content` folder of your site. The expected format is markdown.

You can use front-matter, like that:

```
---
title: My title
date: 2019-05-07
---

# My content...
```

The following properties are valid front-matter:

- `title`: The title for your content item.
- `date`: a point in time, used to sort your content items ([more info on the format](https://yaml.org/type/timestamp.html)).

### Templating

You have 2 html files to provide, they must be in the `templates` folder of your site:

- `list.html`: for the list of items
- `page.html`: for a content item

TODO available variables

### Running

Run `beulogue` in `my-website` folder. Voilà !

## Notes

`beulogue` is an experiment to discover the [Crystal](https://crystal-lang.org/) programming language, 2 years after playing with [the same concept with Node.js](https://www.npmjs.com/package/beulogue).

`beulogue` aims to stay simple and provide the following for the first version:

- [x] mardown files to html pages
- [x] basic templating (pages)
- [x] basic templating (list)
- [x] markdown front-matter
- [ ] multilingual site
- [ ] rss
- [ ] shortcodes

And maybe at some point:

- [ ] tags
- [ ] drafts
- [ ] pagination
- [ ] livereload

## Development

TODO: Write development instructions here

### Contributing

1. Fork it (<https://github.com/your-github-user/beulogue/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### Contributors

- [Siegfried Ehret](https://github.com/SiegfriedEhret) - creator and maintainer
