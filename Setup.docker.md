# Setup docker

#### Depends

* Docker ~> 18.03.1-ce
* docker-compose ~> 1.21.1  

###### You must have the dependencies installed and running on your operating system

### .env
You can define the ENV settings in the **.env** file.
```bash
# Rails environment
RAILS_ENV=development

# Docker Environment
ENV=development
```

### The control.sh
This is a wrapper to [docker-compose](https://docs.docker.com/compose/) commands. 
It is also responsible for loading environment variables and handle docker containers.

##### Comands
* ```./control.sh build```: will build the image of the main container (rails)
* ```./control.sh up```: will run all containers on stack (mariadb, redis, elasticsearch, rails)
* ```./control.sh stop```: will stop all containers on stack
* ```./control.sh bash```: will enter the bash of the container (rails)
* ```./control.sh logs <service>```: will present the logs of the container

### docker-compose
The orchestration of the used containers can be seen in detail in the file **docker-compose.yml** and **docker-compose.{env}.yml**

## Running

1- Build container  
````bash
./control.sh build
````

2- Up stack
````bash
./control.sh up
````

3- Access project [http://localhost:3000](http://localhost:3000)

