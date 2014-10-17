    time = Time.now.to_i
results = "/tmp/#{time}"

execute "exec-sh" do
    command "#{node[:script][:command]} #{node[:script][:args]} &> #{results}"
    notifies :run, 'execute[print-it]', :delayed
end

#ruby_block "Results" do
#    only_if { ::File.exists?(results) }
#    block do
#      Chef::Log.debug(File.read(results))
#    end
#end

execute "print-it" do
        Chef::Log.debug(File.read(results))
action :nothing
end

