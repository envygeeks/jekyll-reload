# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

# --
task :spec do
  exec "script/test"
end

# --
task :test do
  exec "script/test"
end

# --
task :rubocop do
  exec "script/lint"
end

# --
task :lint do
  exec "script/lint"
end

# --
# If you wish to have extra rake tasks
#   You can load them from within the script
#   directory by creating task.rake.
# --
Dir.glob("script/rake/*.rake").each do |v|
  load v
end
