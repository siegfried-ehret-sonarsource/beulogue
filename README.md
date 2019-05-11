# `beulogue`

> `beulogue` [\bøloɡ\]: french for blog.

## Installation

### Download binaries

- Windows: :x:
- MacOS: :x:
- Linux: :white_check_mark:

Go to the [release page](https://github.com/SiegfriedEhret/beulogue/releases) !

### Build from source

- Clone this repository.
- Install [Crystal](https://crystal-lang.org/) and [Shards](https://github.com/crystal-lang/shards).
- Run `make install` then `make`.
- The `beulogue` binary will be in the `bin/` folder.

## Usage

Add `beulogue` to your path and run `beulogue` !

Here are the possible commands:

- `beulogue` or `beulogue build` to build the site.
- `beulogue help` to show the help.
- `beulogue version` to the the version. Amazing !

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

- `beulogue.yml` is a mandatory configuration file.
- `content/` is the folder with all your pages.
- `templates/` is the folder for your templates.

### Configuration

The configuration file for your site must be `beulogue.yml`.

The possible keys and values are:

- **base** (string): the base url of your website.
- **title** (string): the title of your website.
- **languages** (array of strings): the list of languages for the website. You must add at least one language; the first one is the default one.

Example:

```yaml
base: https://ehret.me
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
description: A small description
---

# My content...
```

The following properties are all mandatory:

- `title`: the title for your content item.
- `date`: a point in time, used to sort your content items ([more info on the format](https://yaml.org/type/timestamp.html)).
- `description`: a small description, used for the rss feed for example.

#### Multilingual site

As explained in the Configuration part, you need at least one language, useful for the `lang` attribute for example.

If our configuration is like the following:

```yaml
base: https://ehret.me
title: My site
languages:
  - en
  - fr
```

Your contents:

- In *english*: filenames will be like `about.md` (no mention about the language in the filename).
- In *other language*: filenames will be like `about.fr.md` if you have a `fr` language.
- Filenames ending with a non defined language will given the default language.

Structure:

- If you have one language: everything will start the root of the `public` folder. A `feed.xml` file will be created in that folder.
- If you have multiple languages: each language will start in the `public/<language>/` folder. A default `index.html` file will be at the root of the `public` folder, redirecting to the default language. A  `feed.xml` file will be created for each language.

### Templating

You have 2 html files to provide, they must be in the `templates` folder of your site:

- `list.html`: for the list of items
- `page.html`: for a content item

The templating engine is [mustache](https://mustache.github.io/).

#### Mustache 101

If you have a variable `title`, use `{{title}}` in your template to display if.

> All variables are HTML escaped by default. If you want to return unescaped HTML, use the triple mustache: {{{name}}}.

If you have a variable `pages` which is a list of objects with a `title` property, you can loop using:

```
{{#pages}}
  <p>{{title}}</p>
{{/pages}}
```

If you want a conditional rendering for `title` whether it has or not a value, use:

```
{{#title}}
  Title is displayed ! {{title}}
{{/title}}
```

Go to the [mustache help](https://mustache.github.io/mustache.5.html) for more info.

#### Variables for the page template

- `title`: the title of the page, from your content front matter.
- `date`: the date of your content, from its front matter
- `content`: your content in html.
- `language`: the language of your content.
- `url`: the url of your page.
- `site`
	- `title`: the title of the site.
	- `languages`: a list of available languages for the site.
- `beulogue`
	- `cwd`: the current working directory.

#### Variables for the list template

- `pages`: a list with page elements (see previous section).
- `language`: the language of the page.
- `site`
	- `title`: the title of the site.
	- `languages`: a list of available languages for the site.
- `beulogue`
	- `cwd`: the current working directory.

## Notes

`beulogue` is an experiment to discover the [Crystal](https://crystal-lang.org/) programming language, 2 years after playing with [the same concept with Node.js](https://www.npmjs.com/package/beulogue).

`beulogue` aims to stay simple and provide the following for the first version:

- [x] mardown files to html pages
- [x] basic templating (pages)
- [x] basic templating (list)
- [x] markdown front-matter
- [x] multilingual site
- [x] rss
- [x] cli, help & debug

And maybe at some point:

- [ ] shortcodes
- [ ] orphan pages
- [ ] links between languages
- [ ] tags
- [ ] drafts
- [ ] pagination
- [ ] livereload

## License

Licensed under the [GPLv3 license](./LICENSE).

## Development

Check the [contributing](./CONTRIBUTING.md) document for some info.

### Contributing

1. Fork it (https://github.com/SiegfriedEhret/beulogue/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### Contributors

- [Siegfried Ehret](https://github.com/SiegfriedEhret) - creator and maintainer
