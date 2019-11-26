require 'youtube-dl.rb'

class Downloader

  def initialize(video_code)
    video_url = "https://fast.wistia.net/embed/iframe/#{video_code}?videoFoam=true"
    @video = YoutubeDL::Video.new(video_url)
  end
  
  def execute
    begin
      config
      
      # Replace file which has not been downloaded
      undownloaded_file = "#{@video.filename}.part" 
      if File.exist?(undownloaded_file)
        puts "Delete file: #{undownloaded_file}"
        File.delete(undownloaded_file)
      end
      
      unless File.exist?(@video.filename)
        puts "Downloading: #{@video.filename}                                       "
        @video.download
        puts "Finish downloading: #{@video.filename}                                      "
      else
        puts "File exist: #{@video.filename}"
      end
    rescue => error
      puts "Error: #{error.inspect}"
    end
  end

  private

  def config
    @video.options.configure do |c|
      c.get_filename = true
      c.output = "download/%(title)s.mp4"
      # c.simulate = true
      c.format = "mp4"
    end
  end

end