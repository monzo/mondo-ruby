guard 'rspec', :version => 2, :cli => '--color --format doc' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/mondo/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch('lib/mondo.rb') { "spec/mondo_spec.rb" }
  watch('spec/spec_helper.rb') { "spec" }
end
