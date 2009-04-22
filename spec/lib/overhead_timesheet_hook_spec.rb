require File.dirname(__FILE__) + '/../spec_helper'

describe OverheadTimesheetHook, "#plugin_timesheet_views_timesheet_group_header" do
  it 'should add a Billable column to the table' do
    OverheadTimesheetHook.instance.plugin_timesheet_views_timesheet_group_header.should eql('<th>Billable</th>')
  end
end

describe OverheadTimesheetHook, "#plugin_timesheet_views_timesheet_time_entry" do
  before(:each) do
  end

  def call_hook(time_entry)
    context = {:time_entry => time_entry}
    return OverheadTimesheetHook.instance.plugin_timesheet_views_timesheet_time_entry(context)
  end

  it 'should add a table cell' do
    time_entry = mock_model(TimeEntry, :billable? => false)
    call_hook(time_entry).should have_tag('td')
  end

  it "should be an empty cell if a time entry isn't billable" do
    time_entry = mock_model(TimeEntry)
    time_entry.should_receive(:billable?).and_return(false)
    call_hook(time_entry).should have_tag('td','')
  end

  it "should have a checkbox if a time entry is billable" do
    time_entry = mock_model(TimeEntry)
    time_entry.should_receive(:billable?).and_return(true)
    call_hook(time_entry).should have_tag('td') do
      with_tag('img[src*=?]','true.png')
    end
  end
end
