require File.dirname(__FILE__) + '/../spec_helper'

# Hack to make RSpec play nicely with call_hook's default contexts
def stub_view_to_use_controller_instance
  self.stub!(:controller).and_return(@controller)
end

describe OverheadIssueHook, "#view_issues_show_details_bottom with the budget disabled", :type => :view do
  include Redmine::Hook::Helper

  before(:each) do
    stub_view_to_use_controller_instance
  end

  it 'should return nothing' do
    project = mock_model(Project)
    project.should_receive(:module_enabled?).at_least(:once).with('budget_module').and_return(false)

    context = {
      :project => project,
      :issue => mock_model(Issue, :project => project, :deliverable => nil)
    }

    call_hook(:view_issues_show_details_bottom, context).strip.should eql('')
  end
end

describe OverheadIssueHook, "#view_issues_show_details_bottom with the budget disabled", :type => :view do
  include Redmine::Hook::Helper

  before(:each) do
    stub_view_to_use_controller_instance
    @project = mock_model(Project)
    @project.should_receive(:module_enabled?).at_least(:once).with('budget_module').and_return(true)
    @issue = mock_model(Issue, :project => @project, :deliverable => nil, :billable_time_spent => nil)
    
    @context = {
      :project => @project,
      :issue => @issue
    }
  end

  it 'should be in a table row' do
    call_hook(:view_issues_show_details_bottom, @context).should have_tag('tr.overhead-plugin')
  end

  it 'should display a label for the billable time' do
    call_hook(:view_issues_show_details_bottom, @context).should have_tag('td.billable-hours','Billable time:')
  end
  
  it 'should display the number of billable hours' do
    @issue.should_receive(:billable_time_spent).and_return(2.0)
    call_hook(:view_issues_show_details_bottom, @context).should have_tag('td','2.00 hours')
  end
end
