# frozen_string_literal: true

desc 'Enforce your Cased CLI controls before the Rake task is executed'
task :guard do
  next if Cased.config.guard_application_key.blank?

  session = Cased::CLI::InteractiveSession.start
  next unless session.record_output?

  exit unless Cased::CLI::Session.current&.approved?
end
