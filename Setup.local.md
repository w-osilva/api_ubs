# Setup localhost

#### Depends

* MariaDB (used v10.1)
* Redis (used v5.0)  
* Elasticsearch (used v6.4)  

###### You must have the dependencies installed and running on your operating system

### .env
Define the RAILS_ENV in **.env** file.
```bash
RAILS_ENV=development
``` 

### Services  
**MariaDB, Redis, Elasticsearch** have default settings defined. 
If you prefer to adjust then you should set the environment variables in the **.env** file. 
```
... others vars ...

# Mariadb
MYSQL_HOST=127.0.0.1
MYSQL_DATABASE=api_ubs_development
MYSQL_USER=root
MYSQL_PASSWORD=

# Redis
REDIS_HOST=127.0.0.1

# Elasticsearch
ELASTICSEARCH_HOST=127.0.0.1
```
To see the default settings, check the **config/\<service>.yml** file 

### Database
To setup database run:
```bash
rake db:create && \
  rake db:migrate && \
  rake db:seed
```

### Sidekiq
To run sidekiq, open a new terminal, change dir to project directory ```cd path-to-project``` and execute:
```bash
sidekiq -C config/sidekiq.yml
```
To run in daemon mode, add the arg **-d** 

### Puma

Start the app:
```bash
rails s 
```