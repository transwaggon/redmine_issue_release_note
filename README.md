<div>
  <h1>Redmine Plugin "Issue Release Note"</h1>
  <p>The plugin for creating release notes</p>
</div>

## Introduction
This redmine plugin allows you to create a PDF file with release note information.

The plugin is tested with redmine version **4.2.1**

## Installation
Please follow the standard procedure for redmine plugins.
1. Download the plugin source
   * [Git Repo](https://github.com/transwaggon/redmine_issue_release_note)
2. Extract the files to the ``<redmine>/plugin/`` directory
3. Run plugin migration: ``rails redmine:plugins:migrate NAME=redmine_issue_release_note``
   * This will create some default custom fields
5. Restart Redmine

## Configuration
All settings are available on the Redmine plugin page: \
``<servername>/admin/plugins``

### Logos
If you like to display an image in header or footer
you need to place the images by default here.

``<redmine>/public/images/issue_release_note/header_logo.jpg``
``<redmine>/public/images/issue_release_note/footer_logo.jpg``

See plugin configuration page to change the default setting.
