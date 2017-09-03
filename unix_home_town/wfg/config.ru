require 'sinatra'

root = Dir.pwd

map "/dir" do
  run Rack::Directory.new("#{root}")
end

map "/sa" do
  run Sinatra::Application
end

# http://127.0.0.1:9292/sa/fg/util 
get '/fg/:file' do
  @result=`find . -name "*#{params[:file]}*" `.split(/\n/).map{ |file| "<a href='/dir#{file.sub(/./,%q{})}'> #{file}</a>" }.join("<br>")
  code = "<%= @result %>"
  erb code
end

# http://127.0.0.1:9292/sa/search?wd=util+brake+rb 
get '/search' do
  unless params[:wd].nil?
    wds = params[:wd].split(/\s/) 
    first_wd = wds.shift
    if wds.count > 0
      greps = " | grep " + wds.join(" | grep ")
    else
      greps = nil
    end 
    @search_cmd = "find . -name \"*#{first_wd}*\" #{greps} "
    puts @search_cmd 
    search_result = `find . -name "*#{first_wd}*" #{greps}`
    @result = search_result.split(/\n/).map{ |file| "<a href='/dir#{file.sub(/./,%q{})}'> #{file}</a>" }.join("<br>")
  else
    @result = "No find file"
  end
  erb :search
end
