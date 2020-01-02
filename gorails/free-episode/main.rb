require 'parallel'
require_relative 'downloader'

# video_code_list = Array.new

def execute_download(video_url)
  downloader = Downloader.new(video_url)
  downloader.execute
end

file='url_list_1.txt'
File.readlines(file).each do |url|
# url = "https://www.youtube.com/watch?v=kJEuFtBttSI"
  execute_download(url)
end

# Parallel.each(video_code_list, in_threads: 3) { |code| execute_download(code) }
# video_code_list.each {|code| execute_download(code)}

