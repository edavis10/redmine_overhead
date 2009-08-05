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
  

end

describe OverheadBudgetHook, "#plugin_budget_view_deliverable_summary_row", :type => :view do
  include Redmine::Hook::Helper

  before(:each) do
    stub_view_to_use_controller_instance
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
