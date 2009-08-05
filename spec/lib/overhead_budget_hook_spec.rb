require File.dirname(__FILE__) + '/../spec_helper'

# Hack to make RSpec play nicely with call_hook's default contexts
def stub_view_to_use_controller_instance
  self.stub!(:controller).and_return(@controller)
end

describe OverheadBudgetHook, "#plugin_budget_view_deliverable_list_header", :type => :view do
  include Redmine::Hook::Helper

  before(:each) do
    stub_view_to_use_controller_instance
  end
  
  it 'should return a table header with "Overhead Spent"' do
    call_hook(:plugin_budget_view_deliverable_list_header, {}).should have_tag('th','Overhead Spent')
  end
end

describe OverheadBudgetHook, "#plugin_budget_view_deliverable_summary_row", :type => :view do
  include Redmine::Hook::Helper

  before(:each) do
    stub_view_to_use_controller_instance
  end
  
  it 'should return a table cell to align the table' do
    call_hook(:plugin_budget_view_deliverable_summary_row, {}).should have_tag('td')
  end

  describe 'for users with management rights' do
    before(:each) do
      @deliverable = Deliverable.new
      OverheadBudgetHook.instance.stub!(:allowed_management?).and_return(true)
    end

    it 'should display the amount of overhead that has been spent' do
      @deliverable.should_receive(:overhead_spent).and_return(100)
      call_hook(:plugin_budget_view_deliverable_summary_row, {:deliverable => @deliverable}).should match(/100/)
    end

    it 'should display the amount as a currency' do
      @deliverable.should_receive(:overhead_spent).and_return(100)
      call_hook(:plugin_budget_view_deliverable_summary_row, {:deliverable => @deliverable}).should have_tag('td', '$100')
    end

    it 'should round the amount to 0 decimal places' do
      @deliverable.should_receive(:overhead_spent).and_return(105.99)
      call_hook(:plugin_budget_view_deliverable_summary_row, {:deliverable => @deliverable}).should have_tag('td', '$106')
    end
  end

  describe 'for users with management rights' do
    it 'should be an empty table cell' do
      OverheadBudgetHook.instance.stub!(:allowed_management?).and_return(false)
      deliverable = Deliverable.new
      call_hook(:plugin_budget_view_deliverable_summary_row, {:deliverable => deliverable }).should have_tag('td','')
    end
  end
end

describe OverheadBudgetHook, "#plugin_budget_view_deliverable_details_row", :type => :view do
  include Redmine::Hook::Helper

  before(:each) do
    stub_view_to_use_controller_instance
  end
  
  it 'should return an empty table cell to align the table' do
    call_hook(:plugin_budget_view_deliverable_details_row, {}).should have_tag('td','')
  end
end

describe OverheadBudgetHook, "#plugin_budget_view_deliverable_description_row", :type => :view do
  include Redmine::Hook::Helper

  before(:each) do
    stub_view_to_use_controller_instance
  end
  
  it 'should return an empty table cell to align the table' do
    call_hook(:plugin_budget_view_deliverable_description_row, {}).should have_tag('td','')
  end
end
