require "rubygems"
require "bundler/setup"
require "coupler/api"
require "coupler/frontend"

class Redirector
  def call(env)
    response = Rack::Response.new
    response.redirect("/app/")
    response.finish
  end
end

# Figure out configuration path
path =
  if ENV['COUPLER_HOME']
    ENV['COUPLER_HOME']
  else
    case RbConfig::CONFIG['host_os']
    when /mswin|windows/i
      # Windows
      File.join(ENV['APPDATA'], "coupler")
    else
      if ENV['HOME']
        File.join(ENV['HOME'], ".coupler")
      else
        raise "Can't figure out where Coupler lives! Try setting the COUPLER_HOME environment variable"
      end
    end
  end

if !File.exist?(path)
  begin
    Dir.mkdir(path)
  rescue SystemCallError
    raise "Can't create Coupler directory (#{path})! Is the parent directory accessible?"
  end
end

if !File.writable?(path)
  raise "Coupler directory (#{path}) is not writable!"
end

# Create results subdirectory
storage_path = File.join(path, 'data')
if !File.exist?(storage_path)
  Dir.mkdir(storage_path)
end

options = {
  "storage_path" => storage_path,
  "database_uri" => File.join("jdbc:sqlite:#{path}", "coupler.sqlite3"),
  "supervisor_style" => "thread"
}

builder = Coupler::API::Builder.new(options)
app = Rack::Builder.new do
  map "/api" do
    run builder.app
  end

  map "/app" do
    run Coupler::Frontend.new
  end

  run Redirector.new
end

supervisor = builder.supervisor
supervisor.start

run app
