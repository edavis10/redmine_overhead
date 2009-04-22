require File.dirname(__FILE__) + '/../spec_helper'

# Hack to make RSpec play nicely with call_hook's default contexts
def stub_view_to_use_controller_instance
  self.stub!(:controller).and_return(@controller)
end

describe OverheadTimesheetHook, "#plugin_timesheet_views_timesheet_group_header" do
  it 'should add a Billable column to the table' do
    OverheadTimesheetHook.instance.plugin_timesheet_views_timesheet_group_header.should eql('<th>Billable</th>')
  end
end

describe OverheadTimesheetHook, "#plugin_timesheet_views_timesheet_time_entry_sum" do
  it 'should add an empty column to the table' do
    OverheadTimesheetHook.instance.plugin_timesheet_views_timesheet_time_entry_sum.should eql('<td></td>')
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

describe OverheadTimesheetHook, "#plugin_timesheet_views_timesheet_form", :type => :view do
  include Redmine::Hook::Helper

  before(:each) do
    stub_view_to_use_controller_instance
  end
  
  it 'should add a "Billable" label' do
    response = call_hook(:plugin_timesheet_views_timesheet_form, {})
    response.should have_tag('label[class=?][for=?]', 'select_all', 'timesheet[billable][]')
  end

  it 'should add a multple select field called "billable"' do
    response = call_hook(:plugin_timesheet_views_timesheet_form, {})
    response.should have_tag('select[name=?][multiple=multiple]', 'timesheet[billable][]')
  end

  it 'should populate the select field with the possible options of the custom data field' do
    @custom_field = mock_model(TimeEntryActivityCustomField,
                               :possible_values => ['A','B','Nil'],
                               :field_format => 'list')
    TimeEntryActivity.should_receive(:billable_custom_field).and_return(@custom_field)
    
    response = call_hook(:plugin_timesheet_views_timesheet_form, {})
    response.should have_tag('select') do
      with_tag('option[value=?]','A','A')
      with_tag('option[value=?]','B','B')
      with_tag('option[value=?]','Nil','none')
    end
  end
  
  it 'should pre-select the values from the submission'
end
