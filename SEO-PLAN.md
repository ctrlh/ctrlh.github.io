# SEO Plan — Remaining Work

Internal planning doc. Not published to the site.

## After PR #107 merges (manual)

- [ ] Submit `sitemap.xml` in Google Search Console
- [ ] Spot-check live pages: unique titles/descriptions, `/robots.txt`, COVID URLs 404

## SEO deferred / skipped

- [ ] Add "Our Spaces" to nav (orphan-page work was intentionally deferred)
- [ ] Link or noindex orphan pages: `welcome.html`, `support.html`, `get-involved.html`
- [ ] Add open hours to homepage, About, and footer
- [ ] Align with Google Business Profile (hours, photos, NAP)
- [ ] Add `favicon.ico` (referenced in head, missing from repo)
- [ ] Optional: embedded map on About

## Content / crawl hygiene

- [ ] Delete or wire up unused `_posts/` (references missing layouts, never published)
- [ ] Remove or redirect `coming-soon.html` stub
- [ ] Decide fate of `chat2.html` (duplicate of `chat.html`?)

## Analytics

- [ ] UA removed; Matomo retained. Add GA4 only if Google Analytics is still wanted.

## Nice-to-haves (low priority)

- [ ] Replace hand-maintained `sitemap.xml` with `jekyll-sitemap` plugin
- [ ] Strip HTTrack mirror comments from HTML
- [ ] Trim per-page JS bloat for Core Web Vitals
- [ ] Jekyll 4 + GitHub Actions (only if outgrowing Pages built-in build)
- [ ] Blog/events posts for freshness
