class OverheadIssueHook < Redmine::Hook::ViewListener
  def view_issues_show_details_bottom(context={})
    return context[:controller].send(:render_to_string, {
                                       :partial => 'issues/show_overhead',
                                       :locals => {:issue => context[:issue]}
                                     })
  end
end
