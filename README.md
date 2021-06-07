# README

create data base user

sudo -u postgres createuser -s admin
sudo -u postgres psql
\password admin
\password admin
\q


run seed
rails db:seed

rails db:test:prepare


* ...