require_dependency 'deliverable'

module OverheadDeliverablePatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
    end
  end

  module InstanceMethods
    # Cost of time logged to overhead activities
    def overhead_spent
      time_logs = issues.collect(&:time_entries).flatten

      return time_logs.collect {|time_entry|
        if time_entry.billable?
          0
        else
          time_entry.cost
        end
      }.sum 
    end
  end
end
