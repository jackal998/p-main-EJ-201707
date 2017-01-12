`ssh-add`
set :application, 'milkhouse'

set :repo_url, 'git@github.com:jackal998/milkhouses-properties_list.git'
set :deploy_to, '/home/deploy/milkhouse'
set :keep_releases, 5

append :linked_files, 'config/database.yml', 'config/secrets.yml'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

set :passenger_restart_with_touch, true