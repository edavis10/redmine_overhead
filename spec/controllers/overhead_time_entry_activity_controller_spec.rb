require File.dirname(__FILE__) + '/../spec_helper'

describe OverheadTimeEntryActivityController, "#index as non-admin" do
  integrate_views

  before(:each) do
    User.stub!(:current).and_return do
      user = mock_model(User,
                        :admin? => false,
                        :logged? => true,
                        :language => :en,
                        :anonymous? => false,
                        :name => 'Test user',
                        :projects => Project
                        )
    end
  end
  
  it 'should not be successful' do
    get :index
    response.should_not be_success
  end

  it 'should return a 403 status code' do
    get :index
    response.code.should eql("403")
  end
end

describe OverheadTimeEntryActivityController, "#index as admin in js format" do
  integrate_views

  before(:each) do
    User.stub!(:current).and_return do
      user = mock_model(User,
                        :admin? => true,
                        :logged? => true,
                        :language => :en,
                        :anonymous? => false,
                        :name => 'Test user',
                        :projects => Project
                        )
    end
  end
  
  it 'should be successful' do
    get :index
    response.should be_success
  end

  it 'should default to no values if the Billing Status field is invalid' do
    get :index
    assigns[:values].should be_empty
  end

  it 'should handle not finding the Time Entry Activity gracefully' do
    get :index, :custom_field => -10
    response.should be_success
  end

  it 'should render the values partial' do
    get :index
    response.should render_template('overhead_time_entry_activity/_values')
  end

  describe 'with a list custom_field parameter' do
    before(:each) do
      @custom_field = mock_model(TimeEntryActivityCustomField, :possible_values => ['A','B','Nil'], :field_format => 'list')
      TimeEntryActivityCustomField.stub!(:find_by_id).and_return(@custom_field)
    end
  
    it 'should assign values to the possible values of the field' do
      get :index, :custom_field => @custom_field.id
      assigns[:field].should eql(@custom_field)
    end
  
    it 'should find the Billing Status field based on the selected custom_field' do
      TimeEntryActivityCustomField.should_receive(:find_by_id).with(@custom_field.id.to_s).and_return(@custom_field)
      get :index, :custom_field => @custom_field.id
    end

    it 'should render the possible values as a set of options' do
      get :index, :custom_field => @custom_field.id
      response.should have_tag('option[value=?]', 'A','A')
      response.should have_tag('option[value=?]', 'B','B')
      response.should have_tag('option[value=?]', 'Nil','none')
    end
  end

  describe 'with a boolean custom_field parameter' do
    before(:each) do
      @custom_field = mock_model(TimeEntryActivityCustomField, :field_format => 'bool')
      TimeEntryActivityCustomField.stub!(:find_by_id).and_return(@custom_field)
    end
  
    it 'should assign values to the possible values of the field' do
      get :index, :custom_field => @custom_field.id
      assigns[:field].should eql(@custom_field)
    end
  
    it 'should find the Billing Status field based on the selected custom_field' do
      TimeEntryActivityCustomField.should_receive(:find_by_id).with(@custom_field.id.to_s).and_return(@custom_field)
      get :index, :custom_field => @custom_field.id
    end

    it 'should render the values as true or false' do
      get :index, :custom_field => @custom_field.id
      response.should have_tag('option[value=?]', 'true','true')
      response.should have_tag('option[value=?]', 'false','false')
    end
  end
end
