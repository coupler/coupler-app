Coupler Application
===================

This repository contains the necessary configuration for bundling the Coupler
[backend](https://github.com/coupler/coupler-api) and the
[frontend](https://github.com/coupler/coupler-frontend) into a standalone Java
JAR file.

How to run
----------

1. Download release JAR file here: https://github.com/coupler/coupler-app/releases
2. Run the following command from a terminal: `java -jar coupler-app.jar`
3. Open your web browser to the following address: http://127.0.0.1:13603

Notes
-----

A recent version of Java is required to run the Coupler application bundle.

How to build
------------

The build process depends on [JRuby](https://www.jruby.org/). If you have a Mac,
you can use [homebrew](https://formulae.brew.sh/formula/jruby) to install JRuby.
You can also use a Ruby version manager like [rvm](https://rvm.io/) or
[rbenv](https://github.com/rbenv/rbenv) (with the
[ruby-build](https://github.com/rbenv/ruby-build) plugin) to install and manage
JRuby. There's also an Ubuntu package for JRuby.
[Check here](https://www.jruby.org/getting-started) for more ways to install
it.

Once you have JRuby, run these commands from a terminal:

```
git clone https://github.com/coupler/coupler-app.git
cd coupler-app
jruby -S gem install bundler --version '< 2'
jruby -S bundle install
jruby -S bundle exec warble
```

This process should create a file called `coupler-app.jar`, which can be run
with Java to start Coupler.

Please note that the JAR creation process requires Bundler version < 2, at the
time of this writing. JRuby JARs contain Bundler 1, and if you use Bundler 2 on
your system, a conflict will occur.
