# Run the cordapp tutorial on four docker containers (experimental)

The _tutorial-multi_ setup is **experimental**, i.e., doesn't work (yet). The setup is somewhat resource-intensive and unreliable. Maybe someone has an idea how to improve it. I never got it fully running, however, parts of it (e.g., only Controller + NodeA) seemed to work.

Drop me a line / open a github issue if you have an idea...

Clone or download the following github repo to your local host machine: https://github.com/corda/cordapp-tutorial

I cloned it into the _tutorial-multi_, i.e.:

```
-|
 |-basic
 |-corda-docker
 |-tutorial-multi
   |-cordapp-tutorial (this!)
   |- ...
 |- ...
```

If you clone/download the _cordapp-tutorial_ somewhere else, you need to change the relative path in the _tutorial-multi/.env_ docker environment file. The environment variable is referenced in _tutorial-multi/docker-compose.yml_. However, docker build requires a location on the same level or below, relative to the build context. So, the default location is probably good and you shouldn't change it. 

Inside _cordapp-tutorial_, run the `./gradlew deployNodes` command on your host (or .bat if you are on windows), as detailed in the cordapp-tutorial readme file, which leads to _build_ folders being created in _cordapp-tutorial/java-sources_ and _cordapp-tutorial/kotlin-sources_. 

Build the base Docker image: `docker build -t corda:m14 corda-docker` (from the root directory, corda-docker is the build context)

Next, bring up the 4-node network via:

```
cd tutorial-multi
docker-compose up --build
```

As written before, this does not work as I expected. The nodes seem to come up fine but then restart the corda java process again and again. I haven't understood why this is happening. Looking at the logs hasn't led me to the root cause of this issue, yet. It does work with the Controller with 1 other node (I tried with Controller + NodeA and Controller + NodeB), however, as soon as I launch a third node, the java processes on all three nodes respawn and corda doesn't come up again but keeps stuck in an indefinite respawn loop.

I tried to solve it by adding wait times at certain points:

- The corda-webserver does not start before the corda process. Also, it waits for _/etc/service/corda-webserver/certificates/sslkeystore.jks_ to show up. (in dev, the file is auto-generated when starting corda). See _corda-docker/corda-webserver-X.sh_.
- The NodeA/B/C nodes wait for the controller. First, there is a docker dependency via `depends_on` in _tutorial-multi/docker-compose.yml_. Second, I added a _wait_for_controller.sh_ script that should delay the node starts until the Controller's corda-webserver is up.

However, this also didn't help to solve the startup issue of the 4 nodes.