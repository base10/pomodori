# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'spork' do
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

params = {
  wait:           60,
  all_after_pass: false,
  all_on_start:   true
}

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/lib/.+_spec\.rb$})
  watch(%r{^lib/pomodori/(.+)\.rb$})  { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')        { "spec" }
end
