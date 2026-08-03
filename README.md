## pdxhackerspace.org Website

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
