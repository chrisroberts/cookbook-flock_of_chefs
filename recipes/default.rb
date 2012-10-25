%w(libzmq1 libzmq-dev).each do |zk_pkg|
  chef_package zk_pkg
end

chef_gem 'zk'
chef_gem 'celluloid-io' do
  action :install
  version '~> 0.10.0'
end

chef_gem 'dcell'
chef_gem 'flock_of_chefs'
require 'flock_of_chefs'

# Loads DCell up front
node[:chef_client][:load_gems] = {:flock_of_chefs => nil}

ruby_block 'Hook chefs' do
  block do
    FlockOfChefs.start_flocking!(node)
  end
  not_if do
    DCell.me
  end
end

# TODO: Can we get at the runner in a more direct fashion?
ruby_block 'Flocking Chefs' do
  block do
    DCell.me[:flocked_resources].new_run(
      ObjectSpace.each_object(Chef::Runner).map.first
    )
    Chef::Log.info 'This Chef is now flocked'
  end
  wait_until do
    DCell.me
  end
end
