## pdxhackerspace.org Website

[![Build](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/build.yml/badge.svg)](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/build.yml)
[![HTML Proofer](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/html-proofer.yml/badge.svg)](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/html-proofer.yml)
[![Link Check](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/link-check.yml/badge.svg)](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/link-check.yml)
[![Spell Check](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/spellcheck.yml/badge.svg)](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/spellcheck.yml)
[![Asset Check](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/assets.yml/badge.svg)](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/assets.yml)
[![Deploy Pages](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/pages.yml/badge.svg)](https://github.com/ctrlh/ctrlh.github.io/actions/workflows/pages.yml)
[![Built with Jekyll](https://img.shields.io/badge/Built%20with-Jekyll-0969DA?logo=jekyll&logoColor=white)](https://jekyllrb.com/)
[![Ruby](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fctrlh%2Fctrlh.github.io%2Fmaster%2F.ruby-version&query=%24&label=Ruby&color=0969DA&logo=ruby&logoColor=white)](https://www.ruby-lang.org/)

This is the repo for the pdxhackerspace.org site. GitHub Actions builds it with
Jekyll from HTML snippets, includes, and front matter, then publishes the result
to GitHub Pages.

### Running the Site Locally

The site is built by the workflow in `.github/workflows/pages.yml`, which runs
Jekyll itself and uploads the output with `actions/deploy-pages`. GitHub's own
legacy Pages builder is not involved, so the site is not tied to the Jekyll and
Ruby versions that the `github-pages` gem pins. It depends on Jekyll directly
and tracks current releases.

#### Prerequisites

- Ruby 4.0.x (see `.ruby-version`)
- Bundler

#### Setup

Install Ruby if needed. With [rbenv](https://github.com/rbenv/rbenv):

```bash
rbenv install "$(cat .ruby-version)"
```

Or with [RVM](https://rvm.io/):

```bash
rvm install "$(cat .ruby-version)"
rvm use "$(cat .ruby-version)"
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

To build exactly the way the deploy workflow does:

```bash
JEKYLL_ENV=production bundle exec jekyll build --destination _site
```

#### Updating dependencies

Dependabot opens weekly pull requests for the gems and the GitHub Actions, and
the Build workflow checks each one. To update by hand:

```bash
bundle update
```

The workflows track the Ruby 4.0 line rather than a fixed patch release, so CI
picks up new patches on its own. `.ruby-version` names an exact release for
local use; bump it when you install a newer one.

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
`.retireignore.json` records the one accepted exception and why, and
`FRONTEND-DEPS.md` works through what it would take to retire it.
