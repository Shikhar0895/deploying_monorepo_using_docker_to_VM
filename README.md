# What is the aim of this?

Conventional deployement:
Required us to perform below tasks manually:

- ssh into the VM
- pull the code
- build the project
- restart the process with the new build
  All this task needed to be performed every time there is a push to main branch

Deploying a monorepo using docker to VMS solves must of the manual intervention by :-

- On every push to main github actions create new image of the all the packages
- Pushes it to docker hub
- from docker hub one can simply pull the image and run it in the container.

Once the packages are in deployable working state , we need to perform following steps:

- Conatinerize the application
  - Writing docker files
  - Writing docker compose files
- Writing CI CD pipeline to deploy it to docker hub
- Writing CI CD pipeline to pull to virtual machine
