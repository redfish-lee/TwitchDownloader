require './src/video'
require './src/chat'

class Twitch
  def initialize(video_id, client_id, start = 0, stop = 9999999999)
    @video_id = video_id
    @video    = Vod.new(video_id, client_id, start, stop)
    @video.parse

    @date     = @video.list.time.strftime("%Y%m%d")
    @root     = Dir.pwd
    @dir      = "#{@root}/vod/#{@date}_#{@video_id}"
    @name     = "#{@date}_#{@video_id}"
  end

  def dl_list()
    # default path:
    #   video/20010101_xxxxxxxxx/list/20010101_xxxxxxxxx.m3u
    path = "#{@dir}/list"
    FileUtils.mkdir_p(path) unless File.exists?(path)
    File.open("#{path}/#{@name}.m3u" , 'wb') { |f| f.write(@video.m3u) }
    File.open("#{path}/#{@name}.m3u8", 'wb') { |f| f.write(@video.m3u8) }
  end

  def dl_vod()
    path = "#{@dir}"

    FileUtils.mkdir_p(path) unless File.exists?(path)

    File.open("#{path}/#{@name}.ts", 'wb') do |file|
      # dowload video by thread and concat each files after threads join
      # first arg is thread number default 4
      @video.download_thread(4) do |part|
        file.write(part)
      end
    end
  end

  def dl_chat()
    path = "#{@dir}/chat"
    FileUtils.mkdir_p(path) unless File.exists?(path)

    messages  = Chat.new(@video_id)

    file_text = File.open("#{path}/#{@name}.txt", "wb")
    file_json = File.open("#{path}/#{@name}.json", "wb")

    messages.each do |message|
      date    = message.time
      sender  = message.from
      text    = message.message

      # output files
      msg = "%s %s: %s\n" % [date, sender, text]
      file_text.write(msg          + "\n")
      file_json.write(message.data + "\n")

      # print console
      puts "\033[94m" + date + " \033[92m" + sender + "\033[0m" + ": " + text
    end

    file_text.close
    file_json.close
  end
end
