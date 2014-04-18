#file "/tmp/cwlogs" do
#  owner "root"
#  group "root"
#  mode "0755"
#  content "[general]\nstate_file = /tmp/watchstate\n[/var/log/kern.log]\ndatetime_format = %b %d %H:%M:%S\nlog_group_name = /var/log/kern.log\nfile = /var/log/kern.log\nlog_stream_name = ::hostname::"
#  action :create_if_missing
#end

template "/tmp/cwlogs.cfg" do
  cookbook "sample"
  source "cwlogs.cfg.erb"
  owner "root"
  group "root"
  mode 0644
end
