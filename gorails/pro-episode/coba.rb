require 'ruby-progressbar'

def download url, file, folder
  pbar = nil
  open(url, "rb",
    :content_length_proc => lambda {|t|
     if t && 0 < t
       pbar = ProgressBar.create(title: file, total:t, progress_mark:'█'.encode('utf-8')) 
     end
    },
    :progress_proc => lambda {|s|
     pbar.progress = s if pbar
    }) do |page|
    File.open("#{folder}/#{file}", "wb") do |f|
      while chunk = page.read(1024)
        f.write(chunk)
      end
    end
  end
end

download "https://fast.wistia.net/embed/iframe/jivbgkjqpd?videoFoam=true", 'mmmm.mp4', 'download/'