# Run the cordapp tutorial on four docker containers (experimental)

The _tutorial-multi_ setup is **experimental**, i.e., doesn't work (yet). The setup is somewhat resource-intensive and unreliable. Maybe someone has an idea how to improve it. I never got it fully running, however, parts of it (such as only Controller + NodeA) seemed to work. Certainly, there is something wrong with my configs and I suspect a race condition or network configuration mistake. Will investigate further if I find time. Drop me a line / open a github issue if you have an idea...

Clone or download the following github repo to your local host machine: https://github.com/corda/cordapp-tutorial

I cloned it to the root path of the github repo directory, i.e.:

```
-|
 |-basic
 |-corda-docker
 |-cordapp-tutorial (this!)
 |-tutorial-multi
 |-tutorial-single
```

If you clone/download the _cordapp-tutorial_ somewhere else, you need to change the relative path in the _tutorial-multi/.env_ docker environment file. The environment variable is referenced in _tutorial-multi/docker-compose.yml_.

Inside _cordapp-tutorial_, run the `./gradlew deployNodes` command on your host (or .bat if you are on windows), as detailed in the cordapp-tutorial readme file, which leads to _build_ folders being created in _cordapp-tutorial/java-sources_ and _cordapp-tutorial/kotlin-sources_. 

Build the base Docker image: `docker build -t corda:m14 corda-docker`

In the _node.conf_ files of **ALL four nodes (Controller, NodeA, NodeB, and NodeC)**, change the IP:port mappings according to the network in the _tutorial-multi/docker-compose.yml_ network configurations: see _tutorial-multi/node-confs_.

For example, _kotlin-source/build/nodes/Controller/node.conf_ should be:

```
extraAdvertisedServiceIds=[
    "corda.notary.validating"
]
myLegalName="CN=Controller,O=R3,OU=corda,L=London,C=UK"
p2pAddress="172.16.238.10:10002"
rpcAddress="172.16.238.10:10003"
rpcUsers=[]
webAddress="172.16.238.10:10004"
```

Next, bring up the 4-node network via:

```
cd tutorial-multi
docker-compose up --build
```

As written before, this does not work as I expected. The nodes seem to come up fine but then restart the corda java process again and again. I haven't understood why this is happening. Looking at the logs hasn't led me to the root cause of this issue, yet.

I tried to solve it by adding wait times at certain points:

- The corda-webserver does not start before the corda process. Also, it waits for _/etc/service/corda-webserver/certificates/sslkeystore.jks_ to show up. (in dev, the file is auto-generated when starting corda). See _corda-docker/corda-webserver-X.sh_.
- The NodeA/B/C nodes wait for the controller. First, there is a docker dependency via `depends_on` in _tutorial-multi/docker-compose.yml_. Second, I added a _wait_for_controller.sh_ script that should delay the node starts until the Controller's corda-webserver is up.

However, this also didn't help to solve the startup issue of the 4 nodes. Maybe, the java processes don't have enough resources, but at this point I am just guessing.