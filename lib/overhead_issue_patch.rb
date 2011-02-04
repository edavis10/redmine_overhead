module OverheadIssuePatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
    end
  end

  module InstanceMethods
    def billable_time_spent
      time_entry_hours_based_on_billable_flag(true)
    end

    def overhead_time_spent
      time_entry_hours_based_on_billable_flag(false)
    end

    private
    # Totals time_entries that are billable (true) or overhead (false)
    # and returns the rounded value
    def time_entry_hours_based_on_billable_flag(billable_flag=true)
      time = time_entries.inject(0.0) {|sum, time_entry|
        sum += time_entry.hours if time_entry.billable? == billable_flag
        sum
      }
      return 0 if time <= 0
      return time

    end
  end
end

