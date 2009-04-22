class OverheadTimesheetHook < Redmine::Hook::ViewListener

  # Adds a table header "Billable" to the report results
  def plugin_timesheet_views_timesheet_group_header(context={})
    return content_tag(:th, l(:overhead_field_billable))
  end

  # Adds a blank table cell to the issue grouping option
  def plugin_timesheet_views_timesheet_time_entry_sum(context={})
    return content_tag(:td, '')
  end
  
  # Adds the gree checkbox image if the TimeEntry is billable
  def plugin_timesheet_views_timesheet_time_entry(context={})
    time_entry = context[:time_entry]
    if time_entry && time_entry.billable? 
      content_tag(:td, image_tag('true.png'), :style => "text-align:center;")
    else 
      content_tag(:td,'') 
    end 
  end
end
