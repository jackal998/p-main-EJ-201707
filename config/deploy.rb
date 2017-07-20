`ssh-add`
set :application, 'p-main-EJ-201707'

set :repo_url, 'git@github.com:jackal998/p-main-EJ-201707.git'
set :deploy_to, '/home/deploy/p-main-EJ-201707'
set :keep_releases, 5

append :linked_files, 'config/database.yml', 'config/secrets.yml'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

set :passenger_restart_with_touch, true