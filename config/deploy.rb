set :default_environment, { 'PATH' => "/usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH" }
require "bundler/capistrano"
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"

# Don't display unwanted output
logger.level = Logger::DEBUG

set :user, "root"
set :application, "emil_kampp"
set :repository,  "git@github.com:ekampp/emil.kampp.git"
set :deploy_to, "/www/#{fetch(:application)}"
set :server_name, "emil.kampp.me"

role :web, "141.0.175.185"
role :app, "141.0.175.185"
role :db,  "141.0.175.185", :primary => true

# Port to start varnish on.
# Thin will start on running, consequtive ports (e.g. 5001, 5002..)
set :server_port, 5000

set :scm, :git
set :git_shallow_clone, 1
set :branch, :master
set :scm_verbose, false

set :use_sudo, false
set :sudo_user, fetch(:user)
default_run_options[:pty] = true

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# Install requirements on the server before setup
before "deploy:setup", "requirements:install"

# Foreman
after "deploy:update", "foreman:setup"
namespace :foreman do
  desc "setup"
  task :setup, :roles => :app do
    run "cd #{current_path} && PORT=#{fetch(:server_port)} bundle exec foreman export upstart /etc/init -a #{application} -u #{user} -c cache=1,web=4,db=1,redis=1 -l #{release_path}/log"
  end
end

# Deploy namespace
namespace :deploy do
  desc "Start the application services"
  task :start, :roles => :app do
    run "start #{application}"
  end

  desc "Stop the application services"
  task :stop, :roles => :app do
    run "stop #{application}"
  end

  desc "Restarts the application services"
  task :restart, roles: :app do
    run "restart #{application}"
  end
end

# Tail logs
namespace :logs do
  desc "tail production log files"
  task :tail, :roles => :app do
    run "tail -f #{shared_path}/log/* /var/log/nginx/*" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end
end

# Precompile assets
after 'deploy:update_code' do
  run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
end

# Some varnish utilities
namespace :varnish do
  desc "Clear the cache"
  task :purge, roles: :web do
    run "curl -X PURGE emil.kampp.me"
  end
end

# Redis
namespace :redis do
  desc "Symlink to shared dir"
  task :symlink do
    run "mkdir -p /www/emil_kampp/shared/db/redis; cd #{current_path}/db; ln -nsf /www/emil_kampp/shared/db/redis redis"
  end
end
before "deploy:restart", "redis:symlink"

# Versioning
namespace :version do
  desc "Tag before release"
  task :tag do
    release = Capistrano::CLI.ui.ask("Select a release type: 1) build 2) revision 3) minor 4) major (default 1): ")
    release = case release.to_i; when 4; "major"; when 3; "minor"; when 2; "revision"; else "build"; end
    system "rake bump:#{release}"
    version = File.read("VERSION")
    description = Capistrano::CLI.ui.ask("Describe the release (one line): ")
    system "git tag -a v#{version} -m '#{description}'"
    puts ""
    puts "+--------------------------------------------------------------------------+"
    puts "| Releasing v#{version}: #{description}".ljust(74, " ") + " |"
    puts "+--------------------------------------------------------------------------+"
    puts "\n"
    system "git commit -am 'Releasing v#{version}: #{description}'"
    system "git push --tags"
  end
end
before "deploy", "version:tag"


desc "Install server-side requirements"
task :install do
  run "echo 'export LANGUAGE=en_US.UTF-8' >> ~/.bashrc"
  run "echo 'export LANG=en_US.UTF-8' >> ~/.bashrc"
  run "echo 'export LC_ALL=en_US.UTF-8' >> ~/.bashrc"
  run "apt-get update"
  run "apt-get -y upgrade"
  run "apt-get -y install build-essential"
  run "apt-get -y install git-core"
  run "apt-get install git -y"
  run "apt-get install varnish -y"
  run "apt-get install nginx -y"
  run "apt-get install htop -y"
  run "apt-get install mongodb -y"
  run "apt-get install redis-server -y"
  run "apt-get install libpq-dev -y"
  run "apt-get install nodejs -y"

  # Stop auto-started services
  run "service varnish stop"
  run "service nginx stop"
  run "service redis-server stop"

  run "sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config;"
  run "sed -i 's/AllowTcpForwarding yes/AllowTcpForwarding no/g' /etc/ssh/sshd_config;"
  run "sed -i 's/X11Forwarding yes/X11Forwarding no/g' /etc/ssh/sshd_config;"
  run "sed -i 's/LogLevel INFO/LogLevel VERBOSE/g' /etc/ssh/sshd_config;"
  run "echo 'AllowUsers root' >> /etc/ssh/sshd_config;"
  run "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDP8ZHOngCZzIV0mEoV+5ZcRrCl+tKH7GdfboZtosOmn+OpVio+iZ7ZC3xmLA4ZAOHWWhJCiqA63bqxV1iYSsCjs3FN/WLNvCAHakJfgP/E5zunWFi/SjGf78QUJ0uD1INUPiRZfVCGaVhF0KZaensvCJPitQwTJa+YmRCUt5pU10NX6xgeQLaj0xKt12LA4/FtHHHg61mB9FKOerQRX2OiwcNae673ayQqfssBlbhQ6N4F6Ja9TaFXNwrVsZnoGNaI/Aux1z+agtbyUJsK/uC8bv0nZitrVdS5M5flkKWyerKtr7kS4nJ6jdRsfAKByrIiG9iFUNX9ef23w6d1LLZz emil@kampp.me' >> ~/.ssh/authorized_keys"
  run "mkdir -p ~/.ssh"
  run "chmod 700 ~/.ssh"
  run "ssh-keygen -t rsa -b 4096 # 4096 bit encryption"
  run "sudo service ssh restart"
  run "apt-get install zlib1g-dev"
  run "git clone git://github.com/sstephenson/rbenv.git /usr/local/rbenv"
  run "echo '# rbenv setup' > /etc/profile.d/rbenv.sh"
  run "echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh"
  run "echo 'export PATH=\"$RBENV_ROOT/bin:$PATH\"' >> /etc/profile.d/rbenv.sh"
  run "echo 'eval \"$(rbenv init -)\"' >> /etc/profile.d/rbenv.sh"
  run "chmod +x /etc/profile.d/rbenv.sh"
  run "source /etc/profile.d/rbenv.sh"
  run "pushd /tmp"
  run "  git clone git://github.com/sstephenson/ruby-build.git"
  run "  cd ruby-build"
  run "  ./install.sh"
  run "popd"
  run "rbenv install 1.9.3-p194"
  run "rbenv global 1.9.3-p194"
  run "rbenv rehash"
  run "apt-get install rubygems -y"
  run "gem install bundler"
  run "apt-get autoclean"
  run "apt-get autoremove"
  run "apt-get clean"

  # Local stuff
  system "gem install bundler"
  system "bundle"
  system "cap deploy:setup"

  puts ""
  puts "Run 'dpkg-reconfigure tzdata' on remote server to change the timezone. It is currently UTC+0000"
  puts "---"
  puts "Add the following key to github as a deployer ssh key, then run 'bundle exec cap deploy:cold' to deploy your application."
  puts capture('ssh root@141.0.175.185 "cat ~/.ssh/id_rsa.pub"')
end
