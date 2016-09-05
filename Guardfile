# Defines the matching rules for Guard.
guard :minitest, spring: true, all_on_start: false do
  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch('test/test_helper.rb')        { "test" }
  watch(%r{^test/support/(.+)\.rb$})  { "test" }

  watch('config/routes.rb')           { "test" }
  watch('app/controllers/application_controller.rb') { "test/controllers" }

  watch(%r{^app/models/(.*?)\.rb$})          { |m| "test/models/#{m[1]}_test.rb" }
  watch(%r{^app/(.+)\.rb$})                  { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^app/(.+)(\.erb|\.slim)$})        { |m| "test/#{m[1]}_test.rb" }

  # Capybara
  watch(%r{^app/views/(.+)/.*\.(erb|slim)$}) { |m| "test/features" }
end
