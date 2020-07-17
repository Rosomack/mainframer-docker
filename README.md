# mainframer-docker
Mainframer setup in docker to easily deploy it on all powerful servers

Cobbled together from:
* https://github.com/crazygit/mainframer-docker
* https://github.com/nomisRev/mainframer-docker

# Build server
In order to build the docker image run following command `docker build -t mainframer-docker .`
  * The docker image is setup to build gradle android projects.

  To run the docker image run `docker run -d -p 2222:22 mainframer-docker`.

# Client

Beside the project specific setup we need 2 more things, an ssh-key in order to make communication between client and server easier to maintain. And a ssh config for our server.

  ```bash
  ssh-keygen -t rsa -f ~/.ssh/remote-builder -q -N ""
  ssh-copy-id -i ~/.ssh/remote-builder root@192.168.1.1 -p 2222

  echo -e "Host REMOTE_BUILDER \n \
             User root \n \
             HostName 192.168.1.1 \n \
             Port 2222 \n \
             IdentityFile ~/.ssh/remote-builder \n \
             PreferredAuthentications publickey \n \
             ControlMaster auto \n \
             ControlPath /tmp/%r@%h:%p \n \
             ControlPersist 1h" >> ~/.ssh/config
  ```
  **REPLACE IP ADDRESS**

To SSH to the docker container: `ssh REMOTE_BUILDER`

For android you can now just copy the mainframer folder and rename it `.mainframer` and you should be go to run ` bash ./mainframer.sh ./gradlew assembleDebug`.

**And now enjoy faster builds**

### DEFAULT USER ROOT:ROOT IS USED IN THIS SETUP.
