function dguard --argument imageTag
	ls Docker* .docker* docker-compose.yml | entr -cd docker build -t $imageTag .
end
