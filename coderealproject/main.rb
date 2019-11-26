require 'fileutils'
require_relative 'grabber'
require_relative 'downloader'

grabber = Grabber.new
project_links = grabber.get_project_links
project_titles = grabber.get_project_titles 

(0...project_links.size - 3).each do |i| # Get Project Link only from Project 1 & 2
  puts "Project: #{project_titles[i]}"

  directory_name = 'downloaded/' + project_titles[i].gsub(' ', '_')
  puts "  > Creating directory '#{directory_name}'."
  FileUtils.mkdir_p(directory_name) unless File.exists?(directory_name)
  puts "  > Directory '#{directory_name}' created."

  task_links = grabber.get_task_links(project_links[i])
  task_titles = grabber.get_task_titles(project_links[i])
  
  task_seq = 0

  (0...task_links.size).each do |j|
    if(j % 2 == 0) # Skip link which is to complete the eps.
      task_seq = task_seq + 1

      video_code = grabber.get_video_code(task_links[j])
      file_name = "#{task_seq}_" + task_titles[j].gsub(' ', '_') + '.mp4'
      
      unless video_code.nil?
        # downloader = Downloader.new(video_code)
        # downloader.dir_name = directory_name
        # downloader.file_name = file_name
        # downloader.execute
        puts video_code
        sleep 2
      end
    end 
  end

end

grabber.remove_session