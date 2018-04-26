# osx-docker-proxy

Configuration files for docker reverse proxy on Os X.

The goal of this project is to set up a reverse proxy to access docker containers from Os X.
To achieve this goal we are going to use DnsMasq and Nginx.

## 1. Install DnsMasq on Os X
The easiest way is using [HomeBrew](https://brew.sh)
```
brew install dnsmasq
```
Create a config directory
```
mkdir -pv $(brew --prefix)/etc/
```
Copy the dnsmasq.conf file from this project to the directory created in the previous step
```
open $(brew --prefix)/etc/
```

Start DnsMasq
```
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
```

Set up DnsMasq to start automatically with Os X
```
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
```

Create a resolver directory
```
sudo mkdir -v /etc/resolver
```

Copy the docker resolver from the osx-docker-proxy to the directory created in the previous step
```
open /etc/resolver
```

## 2. Start osx-docker-proxy
_You will have to perform this operation every time you re-start Os X_

1. Go to the osx-docker-proxy folder.

2. Stop Os X apache server
```
sudo apachectl stop
```
3. Start the docker image as a service
```
docker-compose up -d
```

## 3. Set up your project
1. Check that there is a docker-compose-osx.yml and docker-sync.yml in the root directory of the project.
- If missing, copy the example files from this project and change the `-project-name` attributes to a meaningful name.
**Important !** the name of the VIRTUAL_HOST attribute (docker-compose-osx.yml) can not be the same as the docker container name !!!

2. Start docker on your project
```
docker-sync start
docker-compose -f docker-compose.yml -f docker-compose-osx.yml up -d
```
_Alternatively you can start any project using the start-project.sh script_

3. Test it out, your Docker container should be accessible now.
For example to access the port 80 of the previous example you can use a web browser with the following URL `http://my-project.docker` .


## 4. Optional settings
- Port forwarding.
Sometimes might be useful to expose a service from a container to your local machine.
You can set it up in the `services` section of the docker-compose-osx.yml file:
```
services:
  service-name:
	ports:
	  - 9000:80
```
_In this example we are forwarding the port 80 from the container to localhost:9000 for a service called `service-name`._

Configuration files of this project
-----------------------------------
- dnsmasq.conf
DnsMasq configuration file to point `.docker` to localhost.

- docker
DnsMasq resolver to point `.docker` to localhost.

- docker-compose-osx.yml
Example configuration file for a project.

- docker-sync.yml
Example synchronisation file for a project.

- start-project.sh
Bash file to start docker in a given project.
For exemple, to start a project named `my-project` we would run:
`./start-project.sh my-project/`