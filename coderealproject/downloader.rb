require 'youtube-dl.rb'
require 'whirly'

class Downloader
  attr_accessor :dir_name
  attr_accessor :file_name

  def initialize(video_code)
    video_url = "https://fast.wistia.net/embed/iframe/#{video_code}?videoFoam=true"
    @video = YoutubeDL::Video.new(video_url)
  end
  
  def execute
    begin
      config

      Whirly.configure spinner: "bouncingBar"
      Whirly.start do
        Whirly.status  = "[ Start downloading '#{@file_name}' ....... ]"
        sleep 1
        Whirly.status  = "[ Downloading '#{@file_name}' ............. ]"
        
        # @video.download
        
        Whirly.status  = "[ Finish downloading '#{@file_name}' ...... ]"
        sleep 1
        Whirly.reset
      end

      puts "    - '#{@file_name}' downloaded.                        "
    rescue => error
      puts "    '#{@file_name}' failed to download."
      puts "    #{error.inspect}"
    end
  end

  private

  def config
    video_output = "#{@dir_name}/#{@file_name}"
    @video.options.configure do |c|
      # c.get_filename = true
      c.output = video_output
      c.format = "mp4"
    end
  end
end