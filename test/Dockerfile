#start from an image, (this case node) and linux distribution
FROM node:alpine

#copy program files from cur directory to the image
COPY . /app

#the current working directory
WORKDIR /app

#to execute the command
CMD node app.js


#to start
#docker build -t hello-docker .
#-t for tag and . for current directory to find dockerfile

#docker image ls
#to see the different images

#docker ps -a
#current images that are running, -a to show all even not the ones running

#docker volume ls
#sudo ls -la /home/$USER/data/mariadb
#to check the different volumes that are created
