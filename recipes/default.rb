%w(libzmq1 libzmq-dev).each do |zk_pkg|
  chef_package zk_pkg
end

chef_gem 'flock_of_chefs'
require 'flock_of_chefs'

chef_gem 'celluloid-io' do
  action :install
  version '~> 0.10.0'
end
chef_gem 'dcell'
