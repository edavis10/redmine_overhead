class OverheadTimesheetHook < Redmine::Hook::ViewListener

  def plugin_timesheet_views_timesheet_group_header(context={})
    return content_tag(:th, l(:overhead_field_billable))
  end

  def plugin_timesheet_views_timesheet_time_entry(context={})
    time_entry = context[:time_entry]
    if time_entry && time_entry.billable? 
      content_tag(:td, image_tag('true.png'))
    else 
      content_tag(:td,'') 
    end 
  end
end
