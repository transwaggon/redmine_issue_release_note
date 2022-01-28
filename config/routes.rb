# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'issues/download_release_note/:id', :to => 'issue_release_note#download', :as => 'download_release_note'
get 'release_notes', :to => 'issue_release_note#index'
