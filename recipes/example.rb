if(node.name == 'zkslave.chrisroberts')
  file '/opt/sub-test' do
    action :nothing
    content "Received at: #{Time.now}"
    remote_subscribes :create, 'file[/opt/notify-test]', :node => 'zkslave2.chrisroberts'
  end
else
  file '/opt/notify-test' do
    content 'test'
  end
end
