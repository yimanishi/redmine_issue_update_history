Redmine::Plugin.register :redmine_issue_update_history do
  name 'Redmine Issue Update History plugin'
  author 'Y.Imanishi'
  description 'issue update history'
  version '0.0.1'
  url 'https://github.com/yimanishi/redmine_issue_update_history'
  author_url 'https://github.com/yimanishi/redmine_issue_update_history'

  require 'issue_hooks'
end
