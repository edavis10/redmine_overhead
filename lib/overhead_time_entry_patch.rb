require_dependency 'time_entry'

module OverheadTimeEntryPatch
  def self.included(base)
    base.class_eval do
      unloadable
      delegate :billable?, :to => :activity
    end
  end
end

