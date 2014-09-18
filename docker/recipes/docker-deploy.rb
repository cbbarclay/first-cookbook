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

  script "kill_all_containers" do  
    interpreter "ruby"
    user "root"
    code <<-EOH
      `docker ps -q`.split("n").each do |container_id|
        `docker stop #{container_id}`
      end
      `docker ps -a -q`.split("n").each do |container_id|
        `docker rm #{container_id}`
      end
    EOH
  end

  bash "docker-build" do
    user "root"
    cwd "#{deploy[:deploy_to]}/current"
    code <<-EOH
     docker build -t=#{deploy[:application]} . > #{deploy[:application]}-docker.out
    EOH
  end
  
  bash "docker-run" do
    user "root"
    cwd "#{deploy[:deploy_to]}/current"
    code <<-EOH
     docker run -p #{node[:opsworks][:instance][:private_ip]}:#{deploy[:environment_variables][:service_port]}:#{deploy[:environment_variables][:container_port]} --name #{deploy[:application]} -d #{deploy[:application]}
    EOH
  end

end
