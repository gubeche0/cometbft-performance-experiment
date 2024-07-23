# cometbft-performance-experiment


## 1. Configure the experiment

### 1.1 Configure the image on cloudlab

To execute the experiment, you need to have this repository cloned in all the cloudlab nodes.

Clone this repository in `/usr/local/cometbft-experiment` by the following command:

```bash
cd /usr/local
mkdir cometbft-experiment
sudo chown -R $USER:$USER cometbft-experiment
cd cometbft-experiment
git clone <this-repo-url> .
```

Then, copy your ssh secret key with access to the remote servers in cloudlab and acess to github (if your repository is private) to the `experiment/config/ssh` folder. The secret key must be named `cloud_lab`.

Now you can create the image in cloudlab and start a new experiment using this images for all nodes. You don`t need to recreate the image for every update in the repository. You can update the repository in all nodes using the scripts in the repository.

### 1.2 Configure the ssh access

Execute the script `configure-ssh.sh` to configure the ssh access and update the local repository.

```bash
./experiment/scripts/configure-ssh.sh
```

Now you can access the nodes using the command `ssh node-<node-number>`.

### 1.3 Update the repository in all nodes

To update the repository in all nodes, execute the script `git-pull-all.sh` informing the number of nodes.

```bash
./experiment/scripts/git-pull-all.sh 128
```

### 1.4 Configure the experiment

Now you need to create the configuration file for cometbft. You can use the script `create-configs.sh` informing the number of nodes.

```bash
./experiment/scripts/create-configs.sh 128
```

This script will create the config file, public and private keys for the nodes and copy.

If you execute this script again, it will overwrite the previous configuration and restart the experiment.

### 1.5 [Optional] Configure the network latency

WIP...

### 2 Run the experiment

### 2.1 Start the CometBFT process

To start the CometBFT process in all nodes, execute the script `start-all.sh` informing the number of nodes.

```bash
./experiment/scripts/start-all.sh 128
```

### 2.2 Start the client

To start the client, execute the script `start-all-clients.sh` informing the number of nodes, the number of requests to send (0 to infinite) and the number of clients to execute in each node.

```bash

./experiment/scripts/start-all-clients.sh 128 30 12
```

The script will start the clients in all nodes and wait for the end of the experiment.

### 2.3 Stop the cometbft process

To stop the CometBFT process in all nodes, execute the script `stop-all.sh` informing the number of nodes.

```bash
./experiment/scripts/stop-all.sh 128
```

### 2.4 Collect the logs

To collect the logs from all nodes, execute the script `download-all-logs.sh` informing the number of nodes.

```bash
./experiment/scripts/download-all-logs.sh 128
```

The logs will be downloaded to the `experiment/logsresults` folder.