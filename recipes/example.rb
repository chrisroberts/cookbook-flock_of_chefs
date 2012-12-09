if(node.name == node[:flock_of_chefs][:example][:subscribe_node])
  file '/opt/sub-test' do
    action :nothing
    content "Received at: #{Time.now}"
    remote_subscribes :create, 'file[/opt/notify-test]', :node => node[:flock_of_chefs][:example][:notify_node]
  end
else
  file '/opt/notify-test' do
    content 'test'
  end
end
