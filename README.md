## pdxhackerspace.org Website

This is the repo for the pdxhackerspace.org served using github.com pages.  The
site is compised of markdown, html snippets, and plain text generated using
jekyll, a static site generator.

### Running the Site Locally

#### Linux and Mac OSX

##### Install ruby using RVM

RVM is a ruby version manager allowing you to select specific ruby versions.
See https://rvm.io/ for details.

Install RVM:

```
\curl -sSL https://get.rvm.io | bash -s stable
```

Add RVM to your path:

```
echo 'export PATH="$PATH:$HOME/.rvm/bin"' >> "$HOME/.bashrc"
```

Restart your shell and then install ruby.  This may take a few minutes:

```
rvm install ruby-2.7
```

Select the new ruby version:

```
rvm use ruby-2.7
```

##### Install Jekyll

Jekyll generates a static site from html snippets and plain text.  We use a
specific version:

```
gem install jekyll --version 3.7.3
```

##### Running the site

Jekyll can build and run the site locally:

```
jekyll serve
```

You can now reach the server at `http://127.0.0.1:4000`.  Jekyll will watch for
changes in the repo and update the server automatically.  If this cannot find
jekyl, be sure to `rvm use ...` first.
