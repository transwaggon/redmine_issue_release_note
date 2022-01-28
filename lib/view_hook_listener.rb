class ViewHookListener < Redmine::Hook::ViewListener
  render_on :view_issues_show_details_bottom,
            :partial => 'issue_release_note/button_to_release_note',
            locals: { force_button: true, missing_hint_i18n_key: 'missing_release_note' }
  render_on :view_issues_sidebar_issues_bottom, :partial => 'issue_release_note/link_to_index'
end
