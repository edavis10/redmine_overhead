class OverheadTimesheetHook < Redmine::Hook::ViewListener

  def plugin_timesheet_views_timesheet_group_header(context={})
    return content_tag(:th, l(:overhead_field_billable))
  end
end
