require 'parallel'
require_relative 'downloader'

video_code_list = Array.new

file='url_list_2.txt'
File.readlines(file).each do |line|
  video_code = line[/(?<=amp;wvideo=)(.*)(?="><img )/]
  video_code_list.push(video_code)
end

def execute_download(video_code)
  downloader = Downloader.new(video_code)
  downloader.execute
end

# Parallel.each(video_code_list, in_threads: 3) { |code| execute_download(code) }
video_code_list.each {|code| execute_download(code)}

