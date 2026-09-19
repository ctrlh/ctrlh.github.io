source "https://rubygems.org"

# The site is built by our own Actions workflow (.github/workflows/pages.yml),
# not by GitHub's legacy Pages builder, so it is not tied to the versions the
# github-pages gem pins. Depend on Jekyll directly instead.
gem "jekyll", "~> 4.4"

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.17"
  gem "jekyll-sitemap", "~> 1.4"
end

group :test do
  gem "html-proofer", "~> 5.2"
end
