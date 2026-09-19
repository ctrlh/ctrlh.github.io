#!/usr/bin/env ruby
# frozen_string_literal: true

# Checks the vendored CSS, fonts and icon classes in a built Jekyll site.
#
#   ruby script/check-assets.rb [_site]
#
# Errors fail the build; warnings are informational. URLs that are known to be
# broken and not worth fixing yet live in script/asset-allowlist.txt.

require "set"

SITE_DIR = ARGV.fetch(0, "_site")
ALLOWLIST_FILE = File.expand_path("asset-allowlist.txt", __dir__)

# Font Awesome ships plenty of .fa-* helpers that size, rotate and align an
# icon rather than name one, and they share the icon namespace.
ICON_MODIFIERS = %w[
  fa fa-lg fa-2x fa-3x fa-4x fa-5x fa-fw fa-ul fa-li fa-border fa-pull-left
  fa-pull-right fa-spin fa-pulse fa-rotate-90 fa-rotate-180 fa-rotate-270
  fa-flip-horizontal fa-flip-vertical fa-stack fa-stack-1x fa-stack-2x
  fa-inverse
].to_set

# Directories whose contents should be reachable from the built pages.
VENDOR_DIRS = %w[javascripts js css fonts].freeze

errors = []
warnings = []

def strip_comments(css)
  css.gsub(%r{/\*.*?\*/}m, "")
end

# Turns an href/src/url() reference into a path relative to the site root, or
# nil when it points somewhere we cannot check (another host, a data URI, an
# anchor).
def resolve(ref, from_dir)
  ref = ref.strip.split("#").first.to_s.split("?").first.to_s
  return nil if ref.empty?
  return nil if ref.start_with?("data:", "http://", "https://", "//", "mailto:")

  path = ref.start_with?("/") ? ref.sub(%r{\A/+}, "") : File.join(from_dir, ref)
  File.expand_path(path, "/").sub(%r{\A/}, "")
end

unless File.directory?(SITE_DIR)
  abort "check-assets: #{SITE_DIR} not found. Run `bundle exec jekyll build` first."
end

allowlist = File.exist?(ALLOWLIST_FILE) ? File.readlines(ALLOWLIST_FILE, chomp: true) : []
allowlist = allowlist.reject { |line| line.strip.empty? || line.start_with?("#") }.to_set

html_files = Dir.glob(File.join(SITE_DIR, "**", "*.html"))
abort "check-assets: no HTML found under #{SITE_DIR}." if html_files.empty?

# Every local path the built pages ask the browser to fetch.
referenced = Set.new
stylesheets = Set.new

html_files.each do |file|
  html = File.read(file)
  from_dir = File.dirname(file.sub(%r{\A#{Regexp.escape(SITE_DIR)}/?}, ""))
  from_dir = "" if from_dir == "."

  html.scan(/<link\b[^>]*>/i) do |tag|
    next unless tag =~ /rel\s*=\s*["']?stylesheet/i

    href = tag[/href\s*=\s*["']([^"']+)["']/i, 1]
    path = href && resolve(href, from_dir)
    stylesheets << path if path
  end

  html.scan(/\b(?:src|href)\s*=\s*["']([^"']+)["']/i) do |(ref)|
    path = resolve(ref, from_dir)
    referenced << path if path
  end
end

local_stylesheets = stylesheets.select { |path| File.file?(File.join(SITE_DIR, path)) }
missing_stylesheets = stylesheets - local_stylesheets
missing_stylesheets.each do |path|
  errors << "stylesheet is linked but missing from the build: #{path}"
end

css_sources = local_stylesheets.to_h do |path|
  [path, strip_comments(File.read(File.join(SITE_DIR, path)))]
end

# --- Check 1: every fa-* class used in the HTML is defined in the CSS --------

defined_selectors = Set.new
css_sources.each_value do |css|
  # Rough but adequate selector extraction: the text before each rule's body.
  css.split("}").each do |chunk|
    selector = chunk.split("{").first.to_s
    selector.scan(/\.(-?[A-Za-z_][\w-]*)/) { |(name)| defined_selectors << name }
  end
end

used_icons = {}
html_files.each do |file|
  page = file.sub(%r{\A#{Regexp.escape(SITE_DIR)}/?}, "")
  File.read(file).scan(/\bclass\s*=\s*["']([^"']*)["']/i) do |(value)|
    classes = value.split(/\s+/)
    next unless classes.include?("fa")

    classes.grep(/\Afa-/).each do |icon|
      (used_icons[icon] ||= Set.new) << page
    end
  end
end

used_icons.each do |icon, pages|
  next if ICON_MODIFIERS.include?(icon)
  next if defined_selectors.include?(icon)

  errors << "icon class #{icon} is used but no CSS rule defines it (#{pages.to_a.sort.join(", ")})"
end

# --- Check 2: locally hosted fonts offer a format browsers still support -----

css_sources.each do |path, css|
  css.scan(/@font-face\s*\{(.*?)\}/m) do |(block)|
    family = block[/font-family\s*:\s*([^;]+)/i, 1].to_s.strip.delete("\"'")
    sources = block.scan(/url\(\s*["']?([^"')]+)["']?\s*\)/i).flatten
    next if sources.empty?
    next if sources.all? { |src| src.start_with?("data:", "http://", "https://", "//") }

    next if sources.any? { |src| src =~ /\.woff2?(\?|#|\z)/i }

    errors << "@font-face for #{family} in #{path} has no woff or woff2 source " \
              "(#{sources.join(", ")}); Chrome and Firefox cannot use it"
  end
end

# --- Check 3: every url() in the loaded CSS resolves to a real file ----------

css_urls = Set.new
css_sources.each do |path, css|
  from_dir = File.dirname(path)
  from_dir = "" if from_dir == "."

  css.scan(/url\(\s*["']?([^"')]+)["']?\s*\)/i) do |(ref)|
    target = resolve(ref, from_dir)
    next unless target

    css_urls << target
    next if File.file?(File.join(SITE_DIR, target))
    next if allowlist.include?(target)

    errors << "#{path} references #{ref}, which does not exist in the build"
  end
end

referenced.merge(css_urls)
referenced.merge(local_stylesheets)

# --- Check 4: vendored assets nothing refers to ------------------------------

VENDOR_DIRS.each do |dir|
  Dir.glob(File.join(SITE_DIR, dir, "**", "*")).sort.each do |file|
    next unless File.file?(file)

    path = file.sub(%r{\A#{Regexp.escape(SITE_DIR)}/?}, "")
    next if referenced.include?(path)

    warnings << "unreferenced: #{path} (#{(File.size(file) / 1024.0).round} KB)"
  end
end

# --- Report ------------------------------------------------------------------

unless warnings.empty?
  puts "Warnings (#{warnings.size}):"
  warnings.each { |warning| puts "  #{warning}" }
  puts
end

if errors.empty?
  puts "check-assets: OK - #{used_icons.size} icon classes, " \
       "#{local_stylesheets.size} stylesheets, #{css_urls.size} CSS references."
  exit 0
end

puts "Errors (#{errors.size}):"
errors.each { |error| puts "  #{error}" }
exit 1
