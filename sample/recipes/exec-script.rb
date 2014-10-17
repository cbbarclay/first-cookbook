time = Time.now.to_i
results = "/tmp/#{time}"


value = `#{node[:script][:command]} > #{results}`
Chef::Log.info("Script results:" + File.read(results))
