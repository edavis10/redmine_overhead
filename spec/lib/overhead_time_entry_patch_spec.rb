require File.dirname(__FILE__) + '/../spec_helper'

describe TimeEntry, 'billable?' do
  before(:each) do
    @time_entry = TimeEntry.new
  end

  it 'should be true if the activity is considered billable' do
    @time_entry.should_receive(:activity).and_return do
      mock_model(TimeEntryActivity, :billable? => true)
    end
    @time_entry.billable?.should be_true
  end

  it 'should be false if the activity is considered overhead' do
    @time_entry.should_receive(:activity).and_return do
      mock_model(TimeEntryActivity, :billable? => false)
    end
    @time_entry.billable?.should be_false
  end
end
