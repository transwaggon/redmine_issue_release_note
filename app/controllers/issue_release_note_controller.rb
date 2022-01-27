class IssueReleaseNoteController < ApplicationController
  before_action :find_issue, :only => [:download]

  def download
    respond_to do |format|
      format.pdf do
        send_file_headers! type: 'application/pdf', filename: filename
      end
    end
  end

  private

  def filename
    # todo Make filename configureable
    "#{t('ticket_prefix', default: 'Ticket')} ##{@issue.id} - #{@issue.subject}"
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
