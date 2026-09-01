# Writing a newsletter issue or a blog post

This file is not published. It is listed under `exclude:` in `_config.yml`, so
Jekyll ignores it and it never appears on the site.

Everything dated lives in this directory. There are exactly two kinds of post,
separated by category:

- `newsletter` — the monthly issue. One per month, issue-numbered. Published at
  `/newsletter/YYYY/MM/slug/`, listed on `/newsletter/`.
- `blog` — one-off project write-ups. Published at `/blog/YYYY/MM/slug/`, listed
  on `/blog/`.

Do not invent a third category. Two is what the indexes, feeds, and navigation
know about.

## Adding a newsletter issue

1. Create `_posts/YYYY-MM-DD-month-year.md` (e.g. `2026-10-01-october-2026.md`).
   The date in the filename is required and sets the publication date.
2. Front matter:

   ```yaml
   ---
   title: "PDX Hackerspace // October 2026"
   date: 2026-10-01
   categories: newsletter
   issue: "002"
   hero_image: header_spools_dark_bg.png
   description: "One or two sentences, under ~155 characters. Used for search results and link previews."
   ---
   ```

   `issue` increments by one every month and is zero-padded to three digits.
   `hero_image` is a filename in `/images/`; it is rendered as a full-width
   parallax banner with the title over it, so pick something dark enough that
   white text stays readable.
3. Write the body in Markdown. Use `##` for section headings — the layout
   supplies the `<h1>`. Keep the sections roughly in this order: a short intro
   paragraph, the month's news, the events table, a call to contribute, a
   closing note.
4. No layout in front matter. `_config.yml` applies `layout: post` to
   everything in this directory.

## Adding a blog post

Same file naming and front matter, but `categories: blog`, no `issue`, and the
title is a normal headline rather than the `//` issue format. `/blog/` is
currently `noindex` and unlinked from the navigation — when there are two or
three posts worth reading, drop `noindex: true` from `blog.html` and add a nav
entry in `_includes/header.html`.

## Conventions that keep this maintainable

- Images go in `/images/newsletter/` named `YYYY-MM-description.webp`. Reference
  them with `{{ '/images/newsletter/file.webp' | relative_url }}` and always
  write real alt text.
- Only publish photos the space has permission to publish. Photos of
  identifiable people need their consent; auction listings, press photos, and
  watermarked images are not usable.
- Internal links use `relative_url`, e.g.
  `[what we need]({{ '/what-we-need.html' | relative_url }})`. Bare relative
  paths break on post URLs, which are nested three levels deep.
- In posts, every link that leaves the site opens in a new tab. Kramdown carries
  the attributes on the link:
  `[text](https://example.com){:target="_blank" rel="noopener noreferrer"}`.
  Internal links stay in the same tab.
- The contact form is `{{ site.data.contact.contact_form }}`; addresses, phone
  numbers, and social links come from `_data/contact.yml`. Do not hard-code any
  of them.
- The events table is a snapshot of that month and stays frozen in its issue.
  Link to events.pdxhackerspace.org for the live calendar; never copy a table
  into a page that isn't dated.
- No tags, no author pages, no comments. Pagination is unnecessary until an
  index passes about two dozen entries.
- Verify names, dollar amounts, dates, and weekday/date pairings against a
  source before publishing. A published issue is what search engines and AI
  summaries will quote from then on.

## Checking your work

```bash
bundle install
bundle exec jekyll serve
```

Then open <http://127.0.0.1:4000/newsletter/> and the issue's own URL. Confirm
the hero renders, images load, the events table has borders, and the "All
newsletter issues" link at the bottom works.
