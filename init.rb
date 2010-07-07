require 'redmine'

# Patches to the Redmine core.
require 'dispatcher'
require 'overhead_deliverable_patch'
require 'overhead_hourly_deliverable_patch'
require 'overhead_fixed_deliverable_patch'
require 'overhead_issue_patch'
require 'overhead_time_entry_patch'
require 'overhead_time_entry_activity_patch'
Dispatcher.to_prepare do
  Deliverable.send(:include, OverheadDeliverablePatch)
  HourlyDeliverable.send(:include, OverheadHourlyDeliverablePatch)
  FixedDeliverable.send(:include, OverheadFixedDeliverablePatch)
  Issue.send(:include, OverheadIssuePatch)
  TimeEntry.send(:include, OverheadTimeEntryPatch)
  TimeEntryActivity.send(:include, OverheadTimeEntryActivityPatch)
end

require 'overhead_budget_hook'
require 'overhead_issue_hook'
require 'overhead_timesheet_hook'

Redmine::Plugin.register :redmine_overhead do
  name 'Overhead plugin'
  author 'Eric Davis'
  description 'Overhead is a plugin that can be used to group Time Entry Activities into billable and overhead groups'
  url 'https://projects.littlestreamsoftware.com/projects/redmine-overhead'
  author_url 'http://www.littlestreamsoftware.com'
  version '0.1.0'

  requires_redmine :version_or_higher => '0.8.0'


  settings :default => {
    'custom_field' => nil,
    'billable_value' => nil,
    'overhead_value' => nil
  }, :partial => 'settings/overhead_settings'

end
