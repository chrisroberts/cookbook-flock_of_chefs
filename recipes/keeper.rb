chef_gem 'zk'
require 'zk'
zk_search = 'zk_id:*'
if(node[:flock_of_chefs][:zk_env])
  zk_search << " AND chef_environment:#{node[:flock_of_chefs][:zk_env]}"
end
zk_nodes = search(:node, zk_search).map do |z|
  "#{z[:ipaddress]}:#{z[:zookeeperd][:config][:client_port]}"
end

z = ZK.new(zk_nodes.join(','))
base = "/flock_of_chefs/#{node.chef_environment}"
begin
  z.get(base)
rescue ZK::Exceptions::NoNode
  z.mkdir_p(base)
  z.create(
    File.join(base, 'directory'),
    Marshal.dump(
      :name => node.name,
      :address => node[:ipaddress],
      :port => node[:flock_of_chefs][:port]
    )
  )
end

