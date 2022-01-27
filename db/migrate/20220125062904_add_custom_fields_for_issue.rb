class AddCustomFieldsForIssue < ActiveRecord::Migration[5.2]

  RELEASE_NOTE_FIELDS = [{ name: 'Release Note (de)', type: 'text' },
                         { name: 'Release Date', type: 'date' },
                         { name: 'Release Note (en)', type: 'text' }]

  def up
    last_position = (IssueCustomField.maximum(:position) || 0) + 1
    tracker_ids = Tracker.ids
    RELEASE_NOTE_FIELDS.each_with_index do |item, index|
      create_issue_custom_field(item[:name],
                                send("release_note_#{item[:type]}",
                                     item[:name], last_position+index, tracker_ids))
    end
  end

  def create_issue_custom_field(name, data)
    unless IssueCustomField.exists?(name: name)
      IssueCustomField.create!(data)
    end
  end

  def release_note_date(name, position, tracker_ids)
    {
      "name": name,
      "field_format": 'date',
      "possible_values": [],
      "regexp": "",
      "min_length": nil,
      "max_length": nil,
      "is_required": false,
      "is_for_all": true,
      "is_filter": false,
      "position": position,
      "searchable": false,
      "default_value": "",
      "editable": true,
      "visible": true,
      "multiple": false,
      "format_store": {
        "url_pattern": ""
      },
      "description": "",
      "tracker_ids": tracker_ids
    }
  end

  def release_note_text(name, position, tracker_ids)
    {
      "name": name,
      "field_format": 'text',
      "possible_values": [],
      "regexp": '',
      "min_length": nil,
      "max_length": nil,
      "is_required": false,
      "is_for_all": true,
      "is_filter": false,
      "position": position,
      "searchable": true,
      "default_value": "",
      "editable": true,
      "visible": true,
      "multiple": false,
      "format_store": {
        "text_formatting": "full",
        "full_width_layout": "1"
      },
      "description": "",
      "tracker_ids": tracker_ids
    }
  end

  def down ; end
end
