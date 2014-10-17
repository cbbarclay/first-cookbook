execute "exec-sh" do
    command "{node[:script][:command]} {node[:script][:args]"
end
