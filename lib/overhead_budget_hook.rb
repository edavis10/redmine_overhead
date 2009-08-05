class OverheadBudgetHook < Redmine::Hook::ViewListener

  def plugin_budget_view_deliverable_list_header(context={})
    return content_tag(:th, '')
  end
  
  def plugin_budget_view_deliverable_summary_row(context={})
    return content_tag(:td, '')
  end

  def plugin_budget_view_deliverable_details_row(context={})
    return content_tag(:td, '')
  end

  def plugin_budget_view_deliverable_description_row(context={})
    return content_tag(:td, '')
  end

end
