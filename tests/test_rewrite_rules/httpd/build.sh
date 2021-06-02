# Build a new w3id image
docker container stop w3id
docker image rm w3id
docker image build . -t w3id
docker run --rm -d -p 8091:80 --name w3id -v `pwd`/linkml:/w3id/linkml w3id
