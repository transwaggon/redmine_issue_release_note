require 'redmine'

RN_PUBLIC_FOLDER = File.join(Rails.root, 'public')

Redmine::Plugin.register :redmine_issue_release_note do
  name 'Redmine Issue Release Note plugin'
  author 'Matthias Röttger'
  description 'Provides release notes download for issues'
  version '0.0.2'
  url 'https://github.com/transwaggon/redmine_issue_release_note'
  author_url 'https://github.com/transwaggon'

  requires_redmine version_or_higher: '4.2.1'

  settings default: {
              rn_title_singular: '',
              rn_title_pluralize: '',

              rn_page_margin_left: 15,
              rn_page_margin_top: 22,
              rn_page_margin_right: 15,
              rn_font_size_title: 20,
              rn_font_size_caption: 14,
              rn_font_size_default: 12,

              rn_header_enabled: 'true',
              rn_header_margin: 10,
              rn_header_logo_width: 75,
              rn_header_logo: File.join(RN_PUBLIC_FOLDER, 'images/issue_release_note/header_logo.png'),

              rn_footer_enabled: 'true',
              rn_footer_margin: 20,
              rn_footer_logo_width: 43,
              rn_footer_logo: File.join(RN_PUBLIC_FOLDER, 'images/issue_release_note/footer_logo.png'),
              rn_footer_font_size_company: 7,
              rn_footer_company: nil,

              rn_list_caption_width: 35,
              rn_field_gap: 4,
              rn_time_activity_id: 9,
              rn_override_language: '',
              rn_image_scale: 1.6,
              rn_issue_show_names: 'true',
              rn_names_text: 'Release Note (de)|Release Note (en)',
              rn_name_date: 'Release Date',
              rn_attachment_regex: 'rl|rn|release|note'
            },
           partial: 'settings/issue_release_note_settings'
end

require_relative 'lib/view_hook_listener'
require_relative 'lib/redmine_issue_release_note/patches/issue_patch'
require_relative 'lib/redmine_issue_release_note/export/release_note_pdf'
