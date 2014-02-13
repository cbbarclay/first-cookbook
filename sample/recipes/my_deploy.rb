include_recipe 'deploy'
include_recipe 'my_opsworks_deploy'

node[:deploy].each do |application, deploy|


  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_rails do
    deploy_data deploy
    app application
  end

  my_opsworks_deploy do
    deploy_data deploy
    app application
  end
end
