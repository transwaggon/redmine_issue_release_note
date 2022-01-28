class IssueReleaseNoteController < ApplicationController
  before_action :find_issue, :only => [:download]

  def download
    send_file_headers! type: 'application/pdf', filename: filename
  end

  def index
    params = scary_params
    @no_layout = params[:no_layout].present? && (params[:no_layout].to_s.downcase  == 'true')
    @release_notes = Issue.release_notes
    @release_notes = @release_notes.where('subject like ?', "%#{params[:subject]}%") if params[:subject].present?
    @release_notes = @release_notes.where('value >= ?', params[:release_date_from].to_date) if params[:release_date_from].present?
    @release_notes = @release_notes.where('value <= ?', params[:release_date_until].to_date) if params[:release_date_until].present?

    @limit = per_page_option
    @release_notes_count = @release_notes.count
    @release_notes_pages = Paginator.new @release_notes_count, @limit, params['page']
    @offset ||= @release_notes_pages.offset
    @release_notes = @release_notes.limit(@limit).offset(@offset).to_a

    respond_to do |format|
      format.html { render layout: !@no_layout }
    end
  end

  private

  def filename
    # todo Make filename configurable
    "#{t('ticket_prefix', default: 'Ticket')} ##{@issue.id} - #{@issue.subject}"
  end

  def scary_params
    params.permit(:no_layout, :subject, :release_date_from, :release_date_until, :page)
  end

  def find_issue
    # Issue.visible.find(...) can not be used to redirect user to the login form
    # if the issue actually exists but requires authentication
    @issue = Issue.find(params[:id])
    raise Unauthorized unless @issue.visible?

    @project = @issue.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
