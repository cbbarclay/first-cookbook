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

#need to grep for existing images and docker rmi imagename + docker stop name

  bash "docker-build" do
    user "root"
    cwd "#{deploy[:deploy_to]}/current"
    code <<-EOH
     docker build -t=#{deploy[:application]} . > #{deploy[:application]}-docker.out
     docker run -p #{node[:opsworks][:instance][:private_ip]}:#{deploy[:environment_variables][:service_port]}:#{deploy[:environment_variables][:container_port]} -d #{deploy[:application]}
    EOH
  end

end
