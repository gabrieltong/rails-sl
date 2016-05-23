namespace :sync do

  desc 'Copy common models and tests from Master'
  task :copy do
    source_path = '~/Sites/rails-sl'
    dest_paths = ['~/Sites/rails-sl-client', '~/Sites/rails-sl-admin']

    dest_paths.each do |dest_path|
        # Copy all models & tests
        # %x{rm #{dest_path}/app/models/*.rb}
        %x{cp #{source_path}/app/models/*.rb #{dest_path}/app/models/}
        %x{cp #{source_path}/app/decorators/*.rb #{dest_path}/app/decorators/}
        %x{mkdir -p #{dest_path}/app/validators}
        %x{cp #{source_path}/app/validators/*.rb #{dest_path}/app/validators/}
        

        # %x{cp #{source_path}/test/models/*_test.rb #{dest_path}/test/models/}

        # Fixtures
        # %x{cp #{source_path}/test/fixtures/*.yml #{dest_path}/test/fixtures/}

        # Database YML
        %x{cp #{source_path}/.ruby-version #{dest_path}/}
        %x{cp #{source_path}/.ruby-gemset #{dest_path}/}
        %x{cp #{source_path}/config/environments/*.rb #{dest_path}/config/environments/}
        %x{cp #{source_path}/config/locales/*.yml #{dest_path}/config/locales/}
        %x{cp #{source_path}/db/migrate/*.rb #{dest_path}/db/migrate/}
        %x{cp #{source_path}/config/database.yml #{dest_path}/config/database.yml}
        %x{cp #{source_path}/config/secrets.yml #{dest_path}/config/secrets.yml}
        %x{cp #{source_path}/config/initializers/paperclip.rb #{dest_path}/config/initializers/paperclip.rb}
        %x{cp #{source_path}/config/initializers/state_machine.rb #{dest_path}/config/initializers/state_machine.rb}


        # %x{cp #{source_path}/config/initializers/state_machine.rb #{dest_path}/config/initializers/state_machine.rb}
        # %x{cp #{source_path}/config/initializers/active_record.rb #{dest_path}/config/initializers/active_record.rb}
        # %x{cp #{source_path}/config/initializers/gabriel.rb #{dest_path}/config/initializers/gabriel.rb}
        # %x{cp #{source_path}/config/initializers/time_format.rb #{dest_path}/config/initializers/time_format.rb}
    end
  end
end