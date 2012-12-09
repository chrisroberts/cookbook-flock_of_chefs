default[:flock_of_chefs][:enabled] = true
default[:flock_of_chefs][:port] = '22222'
default[:flock_of_chefs][:bind_addr][:device] = nil
default[:flock_of_chefs][:packages] = %w(libzmq-dev)
default[:flock_of_chefs][:example][:subscribe_node] = 'zkslave.chrisroberts'
default[:flock_of_chefs][:example][:notify_node] = 'zkslave2.chrisroberts'
