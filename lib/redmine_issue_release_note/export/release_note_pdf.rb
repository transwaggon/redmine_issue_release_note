
include Redmine::Export::PDF::IssuesPdfHelper
include Redmine::Export::PDF

class RedmineIssueReleaseNote::Export::ReleaseNotePDF < ITCPDF

  RN_PUBLIC_FOLDER = File.join(Rails.root, 'public')
  RN_PDF_AUTHOR = 'Redmine Issue Release Note'
  RN_FONT_SIZE_FOOTER = 10

  # Others

  def getSetting(key)
    Setting.plugin_redmine_issue_release_note[key]
  end

  def getSettingB(key)
    Setting.plugin_redmine_issue_release_note[key] == 'true'
  end

  def getSettingF(key)
    Setting.plugin_redmine_issue_release_note[key]&.to_f
  end

  def Header()
    headerfont = getHeaderFont()
    headerdata = getHeaderData()
    if headerdata['logo'] and (headerdata['logo'] != @@k_blank_image)
      Image(@@k_path_images + headerdata['logo'], '', '', headerdata['logo_width'])
    end
    cell_height = ((getCellHeightRatio() * headerfont[2]) / getScaleFactor()).round(2)
    header_x = getOriginalMargins()['left'] + (headerdata['logo_width'] * 1.1)
    SetTextColor(0, 0, 0)
    # header title
    SetFont(headerfont[0], 'B', headerfont[2] + 1)
    SetX(header_x)
    Cell(0, cell_height, headerdata['title'], 0, 1, '', 0, '', 0)
  end

  def Footer
    footerfont = getFooterFont(nil)
    footerdata = {}
    footerdata['logo'] = getSetting('rn_footer_logo')
    footerdata['logo_width'] = getSettingF('rn_footer_logo_width')

    if footerdata['logo'] and (footerdata['logo'] != @@k_blank_image)
      Image(@@k_path_images + footerdata['logo'], '', '', footerdata['logo_width'])
    end
    header_x = getOriginalMargins()['left'] + (footerdata['logo_width'] + 8)
    SetTextColor(0, 0, 0)
    # Footer Company
    SetFont(footerfont[0], 'B', footerfont[2] + 1)
    SetX(header_x)
    if getSetting('rn_footer_company').present?
      text = get_formatted_text(getSetting('rn_footer_company'))
      set_font(@font_for_footer, '', getSettingF('rn_footer_font_size_company'))
      RDMwriteFormattedCell(get_work_area_width, 5, '', '', text, [], 0)
    end
    write_page_number
  end

  def write_page_number
    line_no = get_alias_num_page + '/' + get_alias_nb_pages
    text_height = get_string_height(get_page_width, line_no)
    set_y(get_page_height-8-text_height)
    set_x(getSettingF('rn_page_margin_right') * -1)
    RDMCell(0, 5, line_no, 0, 0, 'C')
  end

  def set_rn_page(issue)
    set_author(RN_PDF_AUTHOR)
    set_title("##{issue.id} #{issue.subject.to_s}")
    set_margins(getSettingF('rn_page_margin_left'),
                getSettingF('rn_page_margin_top'),
                getSettingF('rn_page_margin_right'))
    alias_nb_pages
  end

  def set_rn_header
    set_header_font(['', '', getSettingF('rn_font_size_title')])
    set_print_header(getSettingB('rn_header_enabled') && File::exists?(getSetting('rn_header_logo')))
    set_header_margin(getSettingF('rn_header_margin'))
    set_header_data(getSetting('rn_header_logo'),
                    getSettingF('rn_header_logo_width'),
                    I18n.t('release_note', default: 'Release Note'))
  end

  def set_rn_footer
    set_footer_font(['', '', RN_FONT_SIZE_FOOTER])
    set_print_footer(getSettingB('rn_footer_enabled') && File::exists?(getSetting('rn_footer_logo')))
    set_footer_margin(getSettingF('rn_footer_margin'))
  end

  def set_default_font(style = '')
    SetFontStyle(style, getSettingF('rn_font_size_default'))
  end

  def set_caption_font(style = '')
    SetFontStyle(style, getSettingF('rn_font_size_caption'))
  end

  def write_caption(issue)
    set_caption_font('B')
    caption = "#{I18n.t('release_note', default: 'Release Note')} ##{issue.id} \"#{issue.subject.to_s}\""
    RDMMultiCell(get_work_area_width, 5, caption)
    set_default_font
  end

  def write_table_cell_item(caption, value = nil)
    set_default_font('B')
    height = [get_string_height(35, caption),
              get_string_height(60, value || '')].max
    cap_width = getSettingF('rn_list_caption_width')
    RDMMultiCell(cap_width, height, caption, 0, '', 0, 0)
    set_default_font
    RDMMultiCell(get_work_area_width-cap_width, height, (value || '').to_s)
  end

  def write_release_note_text(issue, name)
    release = issue.custom_field_values_by_names([name]).first
    write_value(release&.value, issue)
  end

  def write_value(value, issue, border = 'T' )
    return unless value.present?

    set_y(get_y+getSettingF('rn_field_gap'))
    text = get_formatted_text(value)
    RDMwriteFormattedCell(get_work_area_width, 5, '', '', text, issue.attachments, border)
  end

  def get_formatted_text(value)
    Class.new.extend(ApplicationHelper).textilizable(value,
                                                     :object => nil,
                                                     :only_path => false,
                                                     :edit_section_links => false,
                                                     :headings => false,
                                                     :inline_attachments => false)
  end

  def get_work_area_width
    get_page_width-getSettingF('rn_page_margin_left')-getSettingF('rn_page_margin_right')
  end
end