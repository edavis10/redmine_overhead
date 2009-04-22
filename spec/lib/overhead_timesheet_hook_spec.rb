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

  it 'should populate the select field with "Billable" and "Overhead" options' do
    response = call_hook(:plugin_timesheet_views_timesheet_form, {})
    response.should have_tag('select') do
      with_tag('option[value=?]','billable','Billable')
      with_tag('option[value=?]','overhead','Overhead')
    end
  end
  
  it 'should pre-select the values from the submission' do
    context = {
      :params => {:timesheet => {:billable => ['overhead']}}
    }

    response = call_hook(:plugin_timesheet_views_timesheet_form, context)

    response.should have_tag('select') do
      with_tag('option[value=?]','billable','Billable')
      with_tag('option[value=?][selected=selected]','overhead','Overhead')
    end
  end
end

describe OverheadTimesheetHook, "#plugin_timesheet_controller_report_pre_fetch_time_entries", :type => :view do
  include Redmine::Hook::Helper

  before(:each) do
    stub_view_to_use_controller_instance
    @timesheet = Timesheet.new
  end
  
  it 'should do nothing to the activity list if no billable values are submitted' do
    @timesheet.should_not_receive(:activities=)
    context = {:timesheet => @timesheet}
    call_hook(:plugin_timesheet_controller_report_pre_fetch_time_entries, context)
  end


  describe 'should change the activities' do
    before(:each) do
      @billable_activities = [
                              mock_model(TimeEntryActivity, :id => 100),
                              mock_model(TimeEntryActivity, :id => 201),
                              mock_model(TimeEntryActivity, :id => 342)
                             ]
      @overhead_activities = [
                              mock_model(TimeEntryActivity, :id => 102),
                              mock_model(TimeEntryActivity, :id => 202),
                              mock_model(TimeEntryActivity, :id => 344)
                             ]
    end

    def call_hook_with_billable_options(options = [])
      context = {
        :timesheet => @timesheet,
        :params =>
        {
          :timesheet => {
            :billable => options
          }
        }
      }
      call_hook(:plugin_timesheet_controller_report_pre_fetch_time_entries, context)
    end
    
    it 'to only the billable activities when "billable" is selected' do
      TimeEntryActivity.should_receive(:find_billable_activities).and_return(@billable_activities)
      @timesheet.should_receive(:activities=).with([100,201,342])
      call_hook_with_billable_options(['billable'])
    end

    it 'to only the overhead activities when "overhead" is selected' do
      TimeEntryActivity.should_receive(:find_overhead_activities).and_return(@overhead_activities)
      @timesheet.should_receive(:activities=).with([102,202,344])
      call_hook_with_billable_options(['overhead'])
    end

    it 'to all activities when "billable" and "overhead" is selected' do
      TimeEntryActivity.should_receive(:find_billable_activities).and_return(@billable_activities)
      TimeEntryActivity.should_receive(:find_overhead_activities).and_return(@overhead_activities)
      @timesheet.should_receive(:activities=).with([100,102,201,202,342,344])
      call_hook_with_billable_options(['billable','overhead'])
    end

  end
end
