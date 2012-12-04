node[:flock_of_chefs][:packages].each do |zk_pkg|
  chef_package zk_pkg
end

chef_gem 'flock_of_chefs'
require 'flock_of_chefs'

# Loads DCell up front
node[:chef_client][:load_gems] = {:flock_of_chefs => nil}

include_recipe 'flock_of_chefs::keeper'

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
    DCell.me[:resource_manager].new_run(
      ObjectSpace.each_object(Chef::Runner).map.first
    )
    Chef::Log.info 'This Chef is now flocked'
  end
  wait_until do
    DCell.me
  end
end
