class OverheadIssueHook < Redmine::Hook::ViewListener
  def view_issues_show_details_bottom(context={})
    if context[:project].module_enabled?('budget_module')
      return context[:controller].send(:render_to_string, {
                                         :partial => 'issues/show_overhead',
                                         :locals => {:issue => context[:issue]}
                                       })
    else
      return ''
    end
  end
end
