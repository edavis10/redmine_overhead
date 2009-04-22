require File.dirname(__FILE__) + '/../spec_helper'

describe TimeEntryActivity, 'billable?' do
  before(:each) do
    @activity = TimeEntryActivity.new
    
  end

  describe 'with a boolean Custom Field' do
    before(:each) do
      @custom_field = mock_model(TimeEntryActivityCustomField)
      @custom_field.should_receive(:field_format).and_return("bool")
      TimeEntryActivityCustomField.should_receive(:find_by_id).and_return(@custom_field)

      Setting.should_receive(:[]).with('plugin_redmine_overhead').at_least(:once).and_return do
        {
          "custom_field"=> @custom_field.id.to_s,
          "billable_value"=>"true",
          "overhead_value"=>"false"
        }
      end
    end
    
    it 'should be true if the current Billing Status value is the Billable value' do
      @activity.should_receive(:custom_value_for).with(@custom_field).and_return do
        mock_model(CustomValue, :value => "1")
      end
      
      @activity.billable?.should be_true
    end

    it 'should be false if the current Billing Status value is a different Billable value' do
      @activity.should_receive(:custom_value_for).with(@custom_field).and_return do
        mock_model(CustomValue, :value => "0")
      end
      
      @activity.billable?.should be_false
    end
  end

  describe 'with a list Custom Field' do
    before(:each) do
      @custom_field = mock_model(TimeEntryActivityCustomField)
      @custom_field.should_receive(:field_format).and_return("list")
      TimeEntryActivityCustomField.should_receive(:find_by_id).and_return(@custom_field)

      Setting.should_receive(:[]).with('plugin_redmine_overhead').at_least(:once).and_return do
        {
          "custom_field"=> @custom_field.id.to_s,
          "billable_value"=>"is Billable",
          "overhead_value"=>"is not Billable"
        }
      end
    end
    
    it 'should be true if the current Billing Status value is the Billable value' do
      @activity.should_receive(:custom_value_for).with(@custom_field).and_return do
        mock_model(CustomValue, :value => "is Billable")
      end
      
      @activity.billable?.should be_true
    end

    it 'should be false if the current Billing Status value is a different Billable value' do
      @activity.should_receive(:custom_value_for).with(@custom_field).and_return do
        mock_model(CustomValue, :value => "is not Billable")
      end
      
      @activity.billable?.should be_false
    end
  end

  it 'should be false if the Billing Status is not configured' do
    @activity.billable?.should be_false
  end

end


describe TimeEntryActivity, '#billable_custom_field' do
  describe 'with overhead not configured' do
    it 'should return nil' do
      TimeEntryActivity.should_receive(:overhead_configured?).and_return(false)
      TimeEntryActivity.billable_custom_field.should be_nil
    end
  end

  describe 'with overhead configured' do
    it 'should return the custom field used to track Billable' do
      TimeEntryActivity.should_receive(:overhead_configured?).and_return(true)
      custom_field = mock_model(TimeEntryActivityCustomField)
      TimeEntryActivityCustomField.should_receive(:find_by_id).and_return(custom_field)

      TimeEntryActivity.billable_custom_field.should eql(custom_field)
    end
  end
end

describe TimeEntryActivity, '#find_billable_activities' do
  before(:each) do
    TimeEntryActivity.stub!(:overhead_configured?).and_return(true)
    TimeEntryActivity.stub!(:billable_value_configured?).and_return(true)
  end

  it 'should return nothing if none are found' do
    TimeEntryActivity.find_billable_activities.should be_empty
  end

  it 'should return the billable time entry activities' do
    custom_field = mock_model(TimeEntryActivityCustomField,
                               :possible_values => ['A','B','Nil'],
                               :field_format => 'list')
    TimeEntryActivity.stub!(:billable_custom_field).and_return(custom_field)

    activities = [mock_model(TimeEntryActivity), mock_model(TimeEntryActivity)]
    TimeEntryActivity.should_receive(:find).and_return(activities)
    
    response = TimeEntryActivity.find_billable_activities
    response.should eql(activities)
  end
end

describe TimeEntryActivity, '#find_overhead_activities' do
  before(:each) do
    TimeEntryActivity.stub!(:overhead_configured?).and_return(true)
    TimeEntryActivity.stub!(:overhead_value_configured?).and_return(true)
  end

  it 'should return nothing if none are found' do
    TimeEntryActivity.find_overhead_activities.should be_empty
  end

  it 'should return the overhead time entry activities' do
    custom_field = mock_model(TimeEntryActivityCustomField,
                               :possible_values => ['A','B','Nil'],
                               :field_format => 'list')
    TimeEntryActivity.stub!(:billable_custom_field).and_return(custom_field)

    activities = [mock_model(TimeEntryActivity), mock_model(TimeEntryActivity)]
    TimeEntryActivity.should_receive(:find).and_return(activities)
    
    response = TimeEntryActivity.find_overhead_activities
    response.should eql(activities)
  end
end
