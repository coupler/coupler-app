require "rubygems"
require "bundler/setup"
require "coupler-api"
require "coupler-frontend"

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

app = Rack::Builder.new do
  map "/api" do
    options = {
      storage_path: storage_path,
      uri: "jdbc:sqlite://#{path}/coupler.sqlite"
    }
    builder = CouplerAPI::Builder.new(options)
    api = CouplerAPI::Builder.create(options)
    run api
  end

  use Class.new {
    def initialize(app)
      @app = app
    end

    def call(env)
      if env["PATH_INFO"] == "/"
        env["PATH_INFO"] += "index.html"
      end
      @app.call(env)
    end
  }

  run Rack::File.new(CouplerFrontend::PATH)
end
run app
