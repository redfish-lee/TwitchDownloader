require 'optparse'
require './src/twitch'

options = {}
options[:download] = Array.new
OptionParser.new do |opts|
  opts.banner = "Usage: download.rb [options] <url or vod id>"

  opts.on('-l', '--list', 'download vod m3u list and m3u8 list') do |v|
    options[:download].push 'list'
  end

  opts.on('-v', '--vod', 'download vod video as ts file') do |v|
    options[:download].push 'vod'
  end

  opts.on('-c', '--chat', 'download vod chat') do |v|
    options[:download].push 'chat'
  end

  if options[:download].empty?
    options[:download] = ['list', 'vod', 'chat']
  end
end.parse!

p options
p ARGV

if ARGV.length != 1
  puts "ruby download.rb <url> [options]"
  exit
end

# video need arg
video_id  = ARGV[0].split("/")[-1]
client_id = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

# parse video
twitch = Twitch.new(video_id, client_id)
twitch.dl_list if options[:download].include?('list')
twitch.dl_vod  if options[:download].include?('vod')
twitch.dl_chat if options[:download].include?('chat')
