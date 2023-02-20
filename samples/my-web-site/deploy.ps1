echo "started"
docker-compose -f ./docker-compose.yaml down
echo "app stoped"

docker rmi my-web-site-image
echo "image removed"

docker build --no-cache -t my-web-site-image .
echo "build completed"

docker-compose -f ./docker-compose.yaml up -d
echo "app started"