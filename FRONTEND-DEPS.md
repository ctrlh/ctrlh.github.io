# Front-end Dependencies — Terrific, Foundation, jQuery

Internal planning doc. Not published to the site.

Written 2026-09-19. Records why `.retireignore.json` exists and what it would
actually take to remove it.

## The problem

`javascripts/libs.js` loads on every page and contains jQuery 2.1.0. retire.js
flags four advisories against it: CVE-2015-9251, CVE-2019-11358,
CVE-2020-11022 and CVE-2020-11023. All four are fixed in jQuery 3.5.0.

None of them are reachable on a static site like this one — they need
attacker-controlled input reaching jQuery's DOM manipulation or AJAX methods —
so this is hygiene, not an incident. But it keeps the Asset Check workflow
honest only because `.retireignore.json` suppresses it.

## What is actually in libs.js

The file is a single 16,666-line bundle with no build script in the repo:

| Lines (approx) | Contents |
| --- | --- |
| 1 | Modernizr 2.5.2 (custom build) plus yepnope, minified onto one line |
| 6 | jQuery 2.1.0 |
| 560 | Sizzle 1.10.16 (part of jQuery) |
| 9119 | Terrific JavaScript Framework 1.1.1 |
| 10556 | jquery.url plugin |
| 11451 | Foundation 5.5.0 (core plus 14 components) |
| 13708 | jQuery Cookie 1.4.1 |

Because it is pre-built and interleaved, the jQuery inside it cannot be
upgraded independently without regenerating or hand-editing the bundle.

## Terrific is not the blocker

Terrific is a pre-React component framework: `Tc.Application.registerModules()`
in `_includes/head.html` scans the DOM for elements with the `mod` class, reads
the `modXxx` class beside it, and instantiates `Tc.Module.Xxx` from
`javascripts/app.js`, which defines 15 modules. The icon boxes on the home
page, `spaces.html` and `get-involved.html` are `modIconText`, which is what
does their staggered fade-in.

Upgrading it does not help:

- The current release is Terrific 3.0.0, published May 2016, with zero
  dependencies. Version 2 dropped jQuery entirely rather than updating it.
- It is a breaking rewrite. `Tc.Application` became `T.Application`, modules
  became `T.Module` subclasses, and the markup convention changed from
  `class="mod modFoo"` to `data-t-name="Foo"`. All 15 modules in `app.js` and
  every page using `mod modIconText` would need rewriting.
- The project is dormant. Last GitHub push October 2017, `terrifically.org` no
  longer responds, roughly 200 npm downloads a week.
- Most importantly, jQuery would still be needed afterwards by Foundation, the
  jQuery Cookie plugin, the five jQuery plugins `_layouts/default.html` loads
  (countTo, appear, validate, sequence, easing) and `app.js` itself.

## Foundation 5.5.0 is the blocker

jQuery 3.0 removed the `.load()`, `.unload()` and `.error()` event shorthands.
Three call sites in `libs.js` still use them, all inside Foundation:

- line 11496, in `window.Foundation.init` — runs on every
  `jQuery(document).foundation()` call, which `javascripts/app.js:35` makes
- line 13355, in `Foundation.libs.clearing`
- line 16454, in `Foundation.libs.topbar`

Our own code is clean; the only `$.browser` references in `app.js` are inside
comments.

### How little of Foundation this site uses

Only one of Foundation's 14 JS components is referenced anywhere in the markup:
the top bar, via `data-topbar` and `data-options` on the nav in
`_includes/header.html`. There is no `data-reveal`, `data-orbit`,
`data-clearing`, `data-equalizer`, `data-abide` or `data-tooltip` on any page.
The other thirteen components initialize and do nothing.

The CSS usage is almost entirely the grid — `row`, `columns`, `small-12`,
`medium-2/3/4/6/8/9/10/12`, `large-3/4/6/9/10/12`, `large-centered`,
`medium-offset-2` — across 19 HTML files, plus `button radius` on four donate
buttons.

## Two ways out

### Option A: drop Foundation's JavaScript, keep its CSS

Since only the top bar uses Foundation JS, removing Foundation from the bundle
takes all three jQuery-3 blockers with it. No markup changes anywhere; the nav's
responsive toggle, dropdowns and sticky behavior become roughly 50 lines of
vanilla JavaScript that we own. Then swap jQuery 2.1.0 for 3.7.x and the
`.retireignore.json` entry goes away.

Cheapest path. The cost is maintaining the nav code ourselves.

### Option B: migrate to Foundation 6.9.0

Foundation 6.9.0 declares `jquery: >=3.6.0` as a peer dependency, so this also
unblocks the upgrade.

It is less work than it sounds because Foundation 6 still ships a prebuilt
float-grid stylesheet, `dist/css/foundation-float.min.css`. Checked against
this site's markup, every grid class we use survives unchanged in that build —
`.row`, `.columns`, all the `small-`/`medium-`/`large-` sizes,
`.large-centered`, `.medium-offset-2`, `.button`, `.right`, `.sticky`. The 19
files containing grid markup need no edits.

Three things break:

1. `_includes/header.html`. Foundation 6 replaced the v5 top bar entirely;
   `.top-bar-section`, `.title-area`, `.toggle-topbar`, `.has-dropdown` and
   `.contain-to-grid` are all gone, in favour of `title-bar`,
   `responsive-toggle`, `top-bar` and `dropdown-menu`. One 76-line file to
   rewrite, and the bulk of the work.
2. `index.html` line 193, the only block-grid usage
   (`small-block-grid-2 medium-block-grid-3 large-block-grid-4`). Block grid
   was removed; the replacement is `.grid-x` with
   `.small-up-2 .medium-up-3 .large-up-4`.
3. `.radius` on four buttons in `support.html` and `welcome.html`. Removed in
   favour of a Sass variable; either edit the four, or add one CSS rule.

Note that ZURB has moved on. The project now develops a separate suite — Yeti
for websites, Inky for email, Proton as a site builder — described as
"CSS-first, zero-build", with Yeti in beta. Foundation 6.9.0 (September 2024)
is the last stable v6 release, so this is a migration onto a finished branch
rather than an evolving one.

## Re-checking any of this

```bash
# which Foundation JS components the markup actually uses
grep -rhoE "data-(topbar|reveal|orbit|clearing|equalizer|abide|tooltip|dropdown)" \
  --include="*.html" _includes _layouts *.html | sort | uniq -c

# the jQuery 3 blockers (the length guard skips the minified Modernizr line)
awk 'length($0) < 200 && /\.load\(function|\.error\(function|\.unload\(/ \
  {print NR": "$0}' javascripts/libs.js

# whether a Foundation 6 build still carries our grid classes
curl -sL https://cdn.jsdelivr.net/npm/foundation-sites@6.9.0/dist/css/foundation-float.min.css \
  | grep -c '\.large-centered'
```
