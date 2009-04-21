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
    
  end
  
  module InstanceMethods
    # Is the Activity Billable, based on it's custom data?
    def billable?
      if Setting['plugin_redmine_overhead'] && Setting['plugin_redmine_overhead']['custom_field']
        billable_field = TimeEntryActivityCustomField.find_by_id(Setting['plugin_redmine_overhead']['custom_field'])

        if billable_field && field = self.custom_value_for(billable_field)
          if billable_field.field_format == 'bool'
            setting = (Setting['plugin_redmine_overhead']['billable_value'] == "true") ? true : false
            activity_field = (field.value == "1") ? true : false
            return activity_field == setting
          else
            return field.value == Setting['plugin_redmine_overhead']['billable_value']
          end
        else
          return false
        end
      else
        return false
      end
    end
  end    
end

