#
# Cookbook Name:: experimental
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'git-core' do
  action :install
end

service 'experimental' do
  action :start

  supports :status => false, :start => true, :stop => true, :restart => false

  stop_command "pkill -9 -f 'lein run'"
  start_command "cd /mnt/srv/www/current && nohup lein run 80 &> /dev/null </dev/null &"
end

deploy_revision "/mnt/srv/www" do
  repo 'https://github.com/netoneko/ktvt.git'
  migrate false

  create_dirs_before_symlink([])
  symlink_before_migrate({})
  symlinks({})

  before_symlink do
    execute 'lein install' do
      cwd release_path
    end
  end

  before_restart do
    puts 'Before restart'
  end

  after_restart do
    puts 'After restart'
  end

  notifies :stop, "service[experimental]"
  notifies :start, "service[experimental]"

  action :deploy
end
