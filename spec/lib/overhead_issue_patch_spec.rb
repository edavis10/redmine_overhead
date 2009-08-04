require File.dirname(__FILE__) + '/../spec_helper'

def mock_time_entry(hours, billable)
  mock_model(TimeEntry, :hours => hours.to_f, :billable? => billable)
end

describe Issue, '#billable_time_spent' do
  it 'should total the billable time entries' do
    time_entries = [mock_time_entry(12, true),
                    mock_time_entry(13, true)]
    
    issue = Issue.new
    issue.should_receive(:time_entries).and_return(time_entries)
    issue.billable_time_spent.should eql(25.0)
  end
  
  it 'should not include overhead time entries' do
    time_entries = [mock_time_entry(12, true),
                    mock_time_entry(13, true),
                    mock_time_entry(20, false),
                    mock_time_entry(40, false)]
    
    issue = Issue.new
    issue.should_receive(:time_entries).and_return(time_entries)
    issue.billable_time_spent.should eql(25.0)
  end

  it 'should round to the tenths place' do
    time_entries = [mock_time_entry(20, true),
                    mock_time_entry(13.333333, true)]
    
    issue = Issue.new
    issue.should_receive(:time_entries).and_return(time_entries)
    issue.billable_time_spent.should eql(33.3)

  end

  it 'should return 0 if there are no time entries' do
    issue = Issue.new
    issue.billable_time_spent.should eql(0)
  end
end

describe Issue, '#overhead_time_spent' do
  it 'should total the overhead time entries' do
    time_entries = [mock_time_entry(12, false),
                    mock_time_entry(13, false)]
    
    issue = Issue.new
    issue.should_receive(:time_entries).and_return(time_entries)
    issue.overhead_time_spent.should eql(25.0)
  end
  
  it 'should not include billable time entries' do
    time_entries = [mock_time_entry(12, true),
                    mock_time_entry(13, true),
                    mock_time_entry(20, false),
                    mock_time_entry(40, false)]
    
    issue = Issue.new
    issue.should_receive(:time_entries).and_return(time_entries)
    issue.overhead_time_spent.should eql(60.0)
  end

  it 'should round to the tenths place' do
    time_entries = [mock_time_entry(20, false),
                    mock_time_entry(13.333333, false)]
    
    issue = Issue.new
    issue.should_receive(:time_entries).and_return(time_entries)
    issue.overhead_time_spent.should eql(33.3)

  end

  it 'should return 0 if there are no time entries' do
    issue = Issue.new
    issue.overhead_time_spent.should eql(0)
  end
end

