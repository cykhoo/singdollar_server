require 'mina/bundler'
require 'mina/git'
require 'mina/rbenv'
require 'mina/unicorn'

set :domain,        'idaeus.cantab-ip.com'
set :application,   'singdollar'
set :deploy_to,     '/home/deployer/singdollar'
set :repository,    'git@bitbucket.org:cykhoo/singdollar_server.git'
set :branch,        'master'

set :user,          'deployer'
set :forward_agent, true
set :port,          '22'
set :unicorn_pid,   "#{deploy_to}/shared/pids/unicorn.pid"
set :rbenv_path,    '/usr/local/rbenv'

set :shared_paths,  ['config/database.yml', 'log', 'config/secrets.yml', '.env']

task :environment do
  queue %{ echo "-----> Loading environment"
           #{echo_cmd %[source ~/.bashrc]}   }

  queue %{ DOTENVFILE=#{deploy_to}/shared/.env
           if [ -f $DOTENVFILE ]; then
             echo "-----> Loading .env file at $DOTENVFILE";
             #{echo_cmd %[source $DOTENVFILE]}
           fi   }
  invoke :'rbenv:load'
end

task :setup => :environment do

  # set up log file and make it persist between deploys
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  # set up shared configuration directory
  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  # set up .env in shared directory for environment variables
  # populate with values from local .env.production file
  project_dir = File.expand_path('../..', __FILE__)
  env_vars = File.read(project_dir + '/.env.production')
  queue! %[echo -n "#{env_vars}" > "#{deploy_to}/shared/.env"]

  # set up directory to store pid files
  queue! %[mkdir -p "#{deploy_to}/shared/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/pids"]

  # make shared sockets file for unicorn
  queue! %[mkdir -p "#{deploy_to}/shared/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/sockets"]

  # add public key for bitbucket.org into known hosts
  # allows deploy to work the first time without need to manually clone
  queue %[ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'

    to :launch do
      queue "touch #{deploy_to}/tmp/restart.txt"
    end
  end
end
