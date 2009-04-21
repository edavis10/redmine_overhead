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
