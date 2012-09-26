include_recipe 'flock_of_chefs'

if(node[:flock_of_chefs][:registry][:type].to_s == 'zk')
  %w(libzmq1 libzmq-dev zookeeper zookeeper-bin zookeeperd).each do |zk_pkg|
    package zk_pkg
  end

  service 'zookeeper' do
    action [:enable, :start]
  end
end

