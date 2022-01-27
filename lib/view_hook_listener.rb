class ViewHookListener < Redmine::Hook::ViewListener
  render_on :view_issues_show_details_bottom, :partial => 'issue_release_note/button_to_release_note'
end
