# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :environment, 'development'

every '0 6 4 1 *' do
  rake "elcin:sidorova_bd"
end

every '1 6 4 1 *' do
  rake "elcin:misha_bd"
end

every '0 6 3 2 *' do
  rake "elcin:dasha_bd"
end

every '0 6 11 3 *' do
  rake "elcin:masha_bd"
end

every '0 6 25 3 *' do
  rake "elcin:anton_bd"
end

every '0 6 22 4 *' do
  rake "elcin:dima_bd"
end

every '0 6 10 8 *' do
  rake "elcin:denis_bd"
end

every '0 6 18 8 *' do
  rake "elcin:kraef_bd"
end

every '0 6 22 9 *' do
  rake "elcin:vlad_bd"
end

every '0 6 7 12 *' do
  rake "elcin:sereja_bd"
end