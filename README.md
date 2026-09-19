## pdxhackerspace.org Website

[![Build](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/build.yml/badge.svg)](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/build.yml)
[![HTML Proofer](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/html-proofer.yml/badge.svg)](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/html-proofer.yml)
[![Link Check](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/link-check.yml/badge.svg)](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/link-check.yml)
[![Spell Check](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/spellcheck.yml/badge.svg)](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/spellcheck.yml)
[![Asset Check](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/assets.yml/badge.svg)](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/assets.yml)
[![Deploy Pages](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/pages.yml/badge.svg)](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/pages.yml)
[![Built with Jekyll](https://img.shields.io/badge/Built%20with-Jekyll-CC0000?logo=jekyll&logoColor=white)](https://jekyllrb.com/)

This is the repo for the pdxhackerspace.org site, served using GitHub Pages.
The site is built with Jekyll from HTML snippets, includes, and front matter.

### Running the Site Locally

Use the same Jekyll and Ruby versions GitHub Pages runs in production.
The `github-pages` gem pins those for you.

#### Prerequisites

- Ruby 3.3.x (see [GitHub Pages dependency versions](https://pages.github.com/versions/))
- Bundler

#### Setup

Install Ruby 3.3 if needed. With [rbenv](https://github.com/rbenv/rbenv):

```bash
rbenv install 3.3.4
rbenv local 3.3.4
```

Or with [RVM](https://rvm.io/):

```bash
rvm install 3.3.4
rvm use 3.3.4
```

Install gems:

```bash
gem install bundler
bundle install
```

#### Run the site

```bash
bundle exec jekyll serve
```

Open http://127.0.0.1:4000. Jekyll watches for changes and rebuilds automatically.

To match production more closely:

```bash
bundle exec jekyll serve --safe
```

#### Updating dependencies

When GitHub Pages updates its build environment, refresh local gems with:

```bash
bundle update github-pages
```

Check the live pinned versions at https://pages.github.com/versions.json

### Checking assets

The CSS, icon fonts and vendored JavaScript are committed to this repo rather
than pulled from a package manager, so `script/check-assets.rb` guards them
instead. Against a built site it verifies that every `fa-*` class has a CSS
rule, that locally hosted `@font-face` declarations offer a woff source that
current browsers can actually use, and that every `url()` in the stylesheets
resolves to a file that shipped. It also lists vendored files nothing refers
to, which is informational and does not fail the build.

```bash
bundle exec jekyll build --destination _site
ruby script/check-assets.rb _site
```

URLs that are knowingly broken and not worth fixing yet go in
`script/asset-allowlist.txt`, one site-root path per line with a comment
explaining why.

The Asset Check workflow also runs [retire.js](https://retirejs.github.io/)
over `javascripts/` to catch libraries with published vulnerabilities.
`.retireignore.json` records the one accepted exception and why.
