require File.dirname(__FILE__) + '/../spec_helper'

describe OverheadTimesheetHook, "#plugin_timesheet_views_timesheet_group_header" do
  it 'should add a Billable column to the table' do
    OverheadTimesheetHook.instance.plugin_timesheet_views_timesheet_group_header.should eql('<th>Billable</th>')
  end
end
