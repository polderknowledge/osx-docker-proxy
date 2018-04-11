echo Starting up $1
cd $1 
docker-sync start
docker-compose -f docker-compose.yml -f docker-compose-osx.yml up -d
