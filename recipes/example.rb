include_recipe 'flock_of_chefs'

ruby_block 'DCell connect!' do
  block do
    Chef::Log.info "ALL: #{DCell::Node.all.map(&:inspect).join(', ')}"
    dnode = DCell::Node[node[:flock_of_chefs][:example][:node]]
    if(dnode)
      Chef::Log.info "Connected to: #{dnode[:info].hostname}!"
    else
      Chef::Log.warn "Failed to locate DCell node!"
    end
  end
  only_if do
    DCell.me
  end
end
