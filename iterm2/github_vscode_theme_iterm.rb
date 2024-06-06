#!/usr/bin/env ruby
#
# @see https://github.com/cdalvaro/github-vscode-theme-iterm
#

require 'net/http'
require 'plist'
require 'uri'

iterm2_plist_file = "#{__dir__}/com.googlecode.iterm2.plist"
iterm2_plist = Plist.parse_xml(File.read(iterm2_plist_file))
theme_plists = {}

[
  'GitHub Light Default',
  'GitHub Dark Dimmed'
].each do |theme_file|
  itermcolors = "#{theme_file.gsub(' ', '%20')}.itermcolors"
  uri = URI.parse("https://raw.githubusercontent.com/cdalvaro/github-vscode-theme-iterm/main/#{itermcolors}")

  http = Net::HTTP.new(uri.hostname, uri.port)
  http.use_ssl = true

  req = Net::HTTP::Get.new(uri.request_uri)
  res = http.request(req)

  theme = theme_file.split(' ')[1].capitalize
  theme_plists[theme] = Plist.parse_xml(res.body)
end

theme_plists.each do |theme, plist|
  plist.each do |key, value|
    key_with_theme = "#{key} (#{theme})"

    iterm2_plist['New Bookmarks'][0][key_with_theme] = plist[key]
  end
end

File.write(iterm2_plist_file, iterm2_plist.to_plist)
