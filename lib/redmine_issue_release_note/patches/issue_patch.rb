require_dependency 'issue'

module RedmineIssueReleaseNote::Patches::IssuePatch
  extend ActiveSupport::Concern

  included do
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
      # todo move to settings
      custom_field_value_by_names(['Release Datum', 'Release Date'])&.to_date
    end

  end
end

unless Issue.included_modules.include? RedmineIssueReleaseNote::Patches::IssuePatch
  Issue.send :include, RedmineIssueReleaseNote::Patches::IssuePatch
end
