Vagrant.configure("2") do |config|
  # Use Ubuntu 20.04 as the base image
  config.vm.box = "ubuntu/focal64"

  # Configure VM resources
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048" # Allocate 2GB of RAM
    vb.cpus = 2        # Assign 2 CPU cores
  end

  # Sync only the JAR file and Dockerfile into the Vagrant machine
  config.vm.synced_folder ".", "/vagrant"
  # config.vm.synced_folder "C:/devops/java/calculator1/build/libs/calculator-0.0.1-SNAPSHOT.jar", "/vagrant/app.jar", create: false
  # config.vm.synced_folder "C:/devops/java/calculator1/Dockerfile", "/vagrant/Dockerfile", create: false

  # Forward port 8080 to the host machine
  config.vm.network "forwarded_port", guest: 8080, host: 8089

  # Provisioning script to set up Docker and run the container
  config.vm.provision "shell", inline: <<-SHELL
    # Update and install Docker
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker

    # Add the vagrant user to the Docker group
    usermod -aG docker vagrant

    # Restart Docker service to apply changes
    systemctl restart docker

    # Navigate to the /vagrant directory where the synced files are located
    cd /vagrant

    # Build the Docker image
    docker build -t calculator-app .

    # Remove any existing container with the same name
    if [ $(docker ps -aq -f name=calculator-app) ]; then
      docker stop calculator-app
      docker rm calculator-app
    fi

    # Run the Docker container and bind it to all interfaces
    docker run -d -p 8080:8080 --name calculator-app calculator-app
  SHELL
end
