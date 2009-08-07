require File.dirname(__FILE__) + '/../spec_helper'

describe FixedDeliverable, '#labor_budget_spent' do
  def mock_issues_and_time_entries
    @deliverable.should_receive(:issues).at_least(:once).and_return do
      issue1 = mock_model(Issue, :time_entries => [
                                                   mock_model(TimeEntry, :cost => 100, :billable? => true),
                                                   mock_model(TimeEntry, :cost => 200, :billable? => false),
                                                   mock_model(TimeEntry, :cost => 50, :billable? => true)
                                                   ])
      issue2 = mock_model(Issue, :time_entries => [
                                                   mock_model(TimeEntry, :cost => 1000, :billable? => true),
                                                   mock_model(TimeEntry, :cost => 2000, :billable? => false),
                                                   mock_model(TimeEntry, :cost => 5000, :billable? => true)
                                                  ])
      [issue1, issue2]
    end
  end
    
  before(:each) do
    @deliverable = FixedDeliverable.new :fixed_cost => 0
  end

  it 'should be 0 if there are no assigned issues' do
    @deliverable.should_receive(:issues).and_return([])
    @deliverable.labor_budget_spent.should eql(0)
  end

  it 'should total all billable time entries' do
    mock_issues_and_time_entries
    @deliverable.labor_budget_spent.should eql(6150.0)
  end

  it 'should total the billable time entries to the fixed_cost' do
    mock_issues_and_time_entries
    @deliverable.should_receive(:fixed_cost).at_least(:once).and_return(5000)
    @deliverable.labor_budget_spent.should eql(11_150.0)
  end
end
