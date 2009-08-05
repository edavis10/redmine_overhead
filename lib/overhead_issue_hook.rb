class OverheadIssueHook < Redmine::Hook::ViewListener
  def view_issues_show_details_bottom(context={})
    if context[:project].module_enabled?('budget_module')
      billable_label = content_tag(:td,
                                   content_tag(:strong, l(:overhead_billable_time)+":"),
                                   :class => 'billable-hours')
      billable_spent = content_tag(:td, l_hours(context[:issue].billable_time_spent))      

      overhead_label = content_tag(:td,
                                   content_tag(:strong, l(:overhead_overhead_time)+":"),
                                   :class => 'overhead-hours')
      overhead_spent = content_tag(:td, l_hours(context[:issue].overhead_time_spent))      

      return content_tag(:tr,
                         billable_label + billable_spent + overhead_label + overhead_spent,
                         :class => 'overhead-plugin')
    else
      return ''
    end
  end
end
