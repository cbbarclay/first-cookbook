package "daemon"

# script file used by service to launch your java program
file "/tmp/run_script.cmd" do
    content "aws logs push --config-file /root/.aws/awslogs_config.cfg"
end

cookbook_file '/etc/init.d/myservice' do
    source 'etc_initd_myservice'
end

service "myservice" do
    supports :restart => true, :start => true, :stop => true, :reload => true
    action [:enable]
end
