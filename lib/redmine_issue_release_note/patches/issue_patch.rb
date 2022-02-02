require_dependency 'issue'

module RedmineIssueReleaseNote::Patches::IssuePatch
  extend ActiveSupport::Concern

  included do
    def self.release_notes
      custom_field_id = IssueCustomField
                          .where(name: Setting.plugin_redmine_issue_release_note['rn_name_date'] || 'Release Date')
                          .first
      Issue.joins(:custom_values)
           .where(custom_values: { custom_field: custom_field_id } )
           .where.not(custom_values: { value: [nil, ''] })
           .order(value: :desc)
    end

    def developers(time_activity_id = 9)
      activity = TimeEntryActivity.find(time_activity_id)
      return nil unless activity
      time_entries.where(activity: activity).group(:user).order(sum_hours: :desc).sum(:hours).keys
    end

    def main_developer(time_activity_id = 9)
      developers(time_activity_id)&.first
    end

    def custom_field_values_by_names(names)
      visible_custom_field_values.select { |field| names.include? field.custom_field.name}
    end

    def custom_field_values_by_reg(regex)
      visible_custom_field_values.select { |field| field.custom_field.name.match? regex}
    end

    def custom_field_value_by_names(names)
      custom_field_values_by_names(names).first&.value
    end

    def release_date
      date_field_name = Setting.plugin_redmine_issue_release_note['rn_name_date'] || 'Release Date'
      custom_field_value_by_names([date_field_name])&.to_date
    end
  end
end

unless Issue.included_modules.include? RedmineIssueReleaseNote::Patches::IssuePatch
  Issue.send :include, RedmineIssueReleaseNote::Patches::IssuePatch
end
