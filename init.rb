require 'redmine'

Redmine::Plugin.register :redmine_overhead do
  name 'Overhead plugin'
  author 'Eric Davis'
  description 'Overhead is a plugin that can be used to group Time Entry Activities into billable and overhead groups'
  url 'https://projects.littlestreamsoftware.com/projects/redmine-overhead'
  author_url 'http://www.littlestreamsoftware.com'
  version '0.1.0'

  requires_redmine :version_or_higher => '0.8.0'

end
