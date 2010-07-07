module OverheadFixedDeliverablePatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
    end
  end

  module InstanceMethods
    # Amount of "billable" money spent on issues.  Similar to +spent+
    # but only billable time.
    def labor_budget_spent
      return 0.0 if self.fixed_cost.nil?
      return self.fixed_cost unless self.issues.size > 0

      # Get all timelogs assigned
      time_logs = self.issues.collect(&:time_entries).flatten

      return fixed_cost + time_logs.collect {|time_log|
        if time_log.billable?
          time_log.cost
        else
          0.0
        end
      }.sum
    end
  end
end
