require 'redmine'

# Patches to the Redmine core.
require 'overhead_deliverable_patch'
require 'overhead_hourly_deliverable_patch'
require 'overhead_fixed_deliverable_patch'
require 'overhead_issue_patch'
require 'overhead_time_entry_patch'
require 'overhead_time_entry_activity_patch'

require 'dispatcher'
Dispatcher.to_prepare do
  require_dependency 'deliverable'
  Deliverable.send(:include, OverheadDeliverablePatch)
  require_dependency 'hourly_deliverable'
  HourlyDeliverable.send(:include, OverheadHourlyDeliverablePatch)
  require_dependency 'fixed_deliverable'
  FixedDeliverable.send(:include, OverheadFixedDeliverablePatch)
  require_dependency 'issue'
  Issue.send(:include, OverheadIssuePatch)
  require_dependency 'time_entry'
  TimeEntry.send(:include, OverheadTimeEntryPatch)
  require_dependency 'enumeration'
  require_dependency 'time_entry_activity'
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
