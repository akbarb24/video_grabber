require 'nokogiri'
require 'mechanize'
require 'io/console'

class Grabber
  $url_base = 'https://coderealprojects.com'

  def initialize
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari 4'
  end

  def get_project_links
    my_projects_page_container.css("a.title").map { |link| link['href'] }
  end

  def get_task_links(url)
    project_page_container(url).css("li.list-group-item a").map { |link| link['href'] }
  end

  def get_project_titles
    my_projects_page_container.css("a.title").map { |link| link.text.strip }
  end

  def get_task_titles(url)
    project_page_container(url).css("li.list-group-item a").map { |link| link.text.strip }
  end

  def get_video_code(url)
    page = fetch_page(url)
    match = page.search("script").text.scan(/wistiaEmbed = Wistia.embed\(\".*\"/)
    return match[0].split("\"")[1] unless match.empty?
  end

  def remove_session
    File.delete("cookies") if File.exist?("cookies")
  end

  private 

  def get_parse_page(page)
    Nokogiri::HTML(page.content.toutf8)
  end

  def login 
    puts "What's your email?"
    email = gets.chomp
    puts "What's your password?"
    password = STDIN.noecho(&:gets).chomp
    
    page = @agent.get("#{$url_base}/login")
    login_page = page.form_with(action: '/login') do |form|
      form['user[email]'] = email
      form['user[password]'] = password
    end.submit
    
    # Save session
    @agent.cookie_jar.save_as('cookies', session: true, format: :yaml)
    
    return login_page
  end

    def fetch_page(url)
    # Load session
    if File.exist?("cookies")
      @agent.cookie_jar.load("cookies")
      page = @agent.get("#{$url_base}#{url}")
    else
      page = login
    end
  end

  def my_projects_page_container
    my_project_page = fetch_page('/myprojects')
    doc = get_parse_page(my_project_page)
    doc.css(".panel-body.panel-pro")
  end

  def project_page_container(url)
    course_page = fetch_page(url)
    doc = get_parse_page(course_page)
    doc.css("ul.list-group")
  end
end