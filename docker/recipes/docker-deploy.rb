include_recipe 'deploy'


node[:deploy].each do |application, deploy|

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  current_dir = ::File.join(deploy[:deploy_to], 'current')

  bash "docker-build" do
    user "root"
    cwd ::File.dirname(current_dir)
    code <<-EOH
     docker build -t=#{deploy[:application]} .
    EOH
  end

end
