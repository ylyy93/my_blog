#!/usr/bin/env ruby
require 'optparse'

options = {
  :subdir => "_posts"
}

parsed = OptionParser.new do |opts|
  opts.banner = 'Usage: newpost --title "post title" [options]'

  opts.on("-t", "--title TITLE") do |t|
    options[:title] = t
    options[:slug] = t.strip.downcase.gsub(/ /, '-')
  end

  opts.on("-d", "--draft", "Create new post in _drafts") do
    options[:subdir] = "_drafts"
  end
end.parse!

if options[:title].nil? or options[:title].strip == ""
  puts "Need post title. Specify using --title"
  exit 2
end

now = Time.now
date_prefix = now.strftime("%Y-%m-%d")
jekyll_dir = File.dirname(File.expand_path('.', __dir__))
posts_dir = File.join(jekyll_dir, options[:subdir])
post = File.join(posts_dir, "#{date_prefix}-#{options[:slug]}.md")

if File.exist?(post)
  puts "File already exists."
  exit 1
end

header = <<-END
---
date: #{now.strftime("%Y-%m-%d %H:%M:%S%z")}
layout: post
slug: "#{options[:slug]}"
title: #{options[:title]}
description:
tags:
---
h1. {{ page.title }}
END

File.open(post, 'w') do |f|
  f << header
end

editor = ENV['EDITOR']
unless editor
  puts "Created new post: \n#{post}"
else
  system(editor, post)
end
