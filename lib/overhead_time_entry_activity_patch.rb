require_dependency 'time_entry_activity'

module OverheadTimeEntryActivityPatch
  def self.included(base)
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
    end

  end
  
  module ClassMethods
    # Returns the CustomField used for tracking Billable activities
    def billable_custom_field
      if overhead_configured?
        TimeEntryActivityCustomField.find_by_id(Setting['plugin_redmine_overhead']['custom_field'])
      end      
    end

    def overhead_configured?
      Setting['plugin_redmine_overhead'] && Setting['plugin_redmine_overhead']['custom_field']
    end

    def billable_value_configured?
      Setting['plugin_redmine_overhead']['billable_value']
    end
    
    def overhead_value_configured?
      Setting['plugin_redmine_overhead']['overhead_value']
    end

    def find_billable_activities
      return [] unless overhead_configured?
      return [] unless billable_value_configured?

      billable_field = TimeEntryActivity.billable_custom_field
      if billable_field
        value = Setting['plugin_redmine_overhead']['billable_value'] == 'true' # convert "true" to true...
        finder = ARCondition.new
        finder.add "#{CustomValue.table_name}.customized_type = '#{TimeEntryActivity.class_name}'"
        finder.add ["#{CustomValue.table_name}.custom_field_id = ?", billable_field.id]
        finder.add ["#{CustomValue.table_name}.value IN (?)", value]
        return TimeEntryActivity.find(:all, :include => :custom_values, :conditions => finder.conditions)
      else
        return []
      end
      
    end

    def find_overhead_activities
      return [] unless overhead_configured?
      return [] unless overhead_value_configured?

      billable_field = TimeEntryActivity.billable_custom_field
      if billable_field
        value = Setting['plugin_redmine_overhead']['overhead_value'] == 'true' # convert "true" to true...
        finder = ARCondition.new
        finder.add "#{CustomValue.table_name}.customized_type = '#{TimeEntryActivity.class_name}'"
        finder.add ["#{CustomValue.table_name}.custom_field_id = ?", billable_field.id]
        finder.add ["#{CustomValue.table_name}.value IN (?)", value]
        
        return TimeEntryActivity.find(:all, :include => :custom_values, :conditions => finder.conditions)
      else
        return []
      end
      
    end
  end
  
  module InstanceMethods
    # Is the Activity Billable, based on it's custom data?
    def billable?
      if overhead_configured?
        billable_field = TimeEntryActivity.billable_custom_field
        return field_equals_the_configured_billable_field?(billable_field)
      else
        return false
      end
    end

    private

    def overhead_configured?
      TimeEntryActivity.overhead_configured?
    end

    # Checks if the field's value equals the  configured billable
    # value.
    def field_equals_the_configured_billable_field?(field=nil)
      return false unless field
      
      custom_value = self.custom_value_for(field)
      return false unless custom_value
      
      if field.field_format == 'bool'
        # Map string values to proper booleans
        setting = (Setting['plugin_redmine_overhead']['billable_value'] == "true") ? true : false
        activity_field = (custom_value.value == "1") ? true : false
        return activity_field == setting
      else
        return custom_value.value == Setting['plugin_redmine_overhead']['billable_value']
      end
    end
  end    
end

