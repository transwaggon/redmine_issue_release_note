module IssueReleaseNoteHelper
  if Rails.const_defined? 'Console'
    include Redmine::I18n
    include ApplicationHelper
    include ActiveSupport::NumberHelper

    # rails console command
    #   reload! && Class.new.extend(IssueReleaseNoteHelper).test(3)
    def test(id)
      ::I18n.locale = :de
      issue_to_release_note Issue.find(id)
    end
  end

  def issues_includes
    unless Issue.included_modules.include? RedmineIssueReleaseNote::Patches::IssuePatch
      Issue.send :include, RedmineIssueReleaseNote::Patches::IssuePatch
    end
  end

  def issue_to_release_note(issue, assoc={})
    issues_includes
    language = Setting.plugin_redmine_issue_release_note['rn_override_language']
    language = language.present? ? language.to_sym : current_language
    pdf = RedmineIssueReleaseNote::Export::ReleaseNotePDF.new(language)
    pdf.set_rn_page(issue)
    pdf.set_rn_header
    pdf.set_rn_footer

    pdf.add_page
    # pdf.write_caption(issue)
    pdf.set_image_scale(Setting.plugin_redmine_issue_release_note['rn_image_scale']&.to_f || 1.6)
    pdf.write_table_cell_item l(:issue_identifier), "##{issue.id}"
    pdf.write_table_cell_item l(:field_subject), issue.subject
    pdf.write_table_cell_item l(:field_project), issue.project
    pdf.write_table_cell_item l(:field_tracker), issue.tracker
    activity_id = Setting.plugin_redmine_issue_release_note['rn_time_activity_id']&.to_i
    pdf.write_table_cell_item l(:issue_developer), issue.main_developer(activity_id) || issue.assigned_to
    pdf.write_table_cell_item l(:release_note_date), format_date(issue.release_date)
    custom_fiels_names = (Setting.plugin_redmine_issue_release_note['rn_names_text'] || '').split('|')
    custom_fiels_names.each do |rn|
      pdf.write_release_note_text(issue, rn)
    end if custom_fiels_names.present?

    if issue.attachments.any?
      regex = /(#{Setting.plugin_redmine_issue_release_note['rn_attachment_regex'] || ''})/i
      issue.attachments.each do |attachment|
        if attachment.description.to_s.match? regex
          pdf.write_value("!#{attachment.filename.gsub(' ', '%20')}!", issue, '')
        end
      end
    end
    if Rails.const_defined? 'Console'
      pdf.output(File.join(Dir.home, 'Downloads/releasenote.pdf'), 'F')
    else
      pdf.output
    end
  end

end
