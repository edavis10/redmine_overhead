class OverheadBudgetHook < Redmine::Hook::ViewListener
  include DeliverablesHelper
  
  def plugin_budget_view_deliverable_list_header(context={})
    return content_tag(:th, l(:overhead_budget_spent))
  end
  
  def plugin_budget_view_deliverable_summary_row(context={})
    if context[:deliverable]
      # Used by allowed_management?
      @project = context[:deliverable].project
      if allowed_management?
        return content_tag(:td, number_to_currency(context[:deliverable].overhead_spent, :precision => 0))
      end
    end

    return content_tag(:td, '')
  end

  def plugin_budget_view_deliverable_details_row(context={})
    return content_tag(:td, '')
  end

  def plugin_budget_view_deliverable_description_row(context={})
    return content_tag(:td, '')
  end

end
