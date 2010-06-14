require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "dynamic-fields"
    gem.summary = %Q{Auto-migrate ActiveRecord models}
    gem.description = %Q{Allows for automatic migrations with ActiveRecord}
    gem.email = "alex@featureless.co.uk"
    gem.homepage = "http://github.com/ajn/dynamic-fields"
    gem.authors = ["Alex Neill"]
    gem.files = FileList['lib/**/*'].to_a
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
