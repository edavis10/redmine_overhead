require File.dirname(__FILE__) + '/../spec_helper'

describe Deliverable, '#overhead_spent' do
  before(:each) do
    @deliverable = Deliverable.new
  end

  it 'should equal the product of overhead timelogs by their cost' do
    issue1 = mock_model(Issue)
    issue1.stub!(:time_entries).and_return do
      [
       mock_model(TimeEntry, :cost => 100.0, :billable? => true),
       mock_model(TimeEntry, :cost => 200.0, :billable? => false)
       ]
    end
    issue2 = mock_model(Issue)
    issue2.stub!(:time_entries).and_return do
      [
       mock_model(TimeEntry, :cost => 10.0, :billable? => false),
       mock_model(TimeEntry, :cost => 40.0, :billable? => false)
       ]
    end
    
    issues = [issue1, issue2]
    
    @deliverable.stub!(:issues).and_return(issues)
    @deliverable.overhead_spent.should eql(250.0)
  end

  it 'should be 0.0 if there are no issues assigned' do
    @deliverable.stub!(:issues).and_return([])
    @deliverable.overhead_spent.should eql(0)
  end

  it 'should be 0.0 if there are no time entries' do
    issue1 = mock_model(Issue, :time_entries => [])
    issue2 = mock_model(Issue, :time_entries => [])

    @deliverable.stub!(:issues).and_return([issue1, issue2])
    @deliverable.overhead_spent.should eql(0)
  end
end
