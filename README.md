# WWQI Search

TODO

## ElasticSearch

TODO

## Neo4j

TODO

## How to set up test-driven Neo4j development with rspec

See
  * https://github.com/maxdemarzi/neography/
  * http://docs.neo4j.org/chunked/1.6.2/server-installation.html

The basic strategy is to run two Neo4j instances, one for development, one for test. We start and stop both not with neography rake tasks, but with `/path/to/neo4j start` and `/path/to/neo4j stop`. You should follow the instructions below for installation.

To run the specs, we have to clear the Neo4j database between each spec. To do this, we have to install the test-delete-db-extension plugin for Neo4j. Neography apparently has a built-in mechanism for interfacing with this plugin, that goes a little something like this:
```
config.before(:each) do
  @neo.clean_database("yes_i_really_want_to_clean_the_database")
end
```
However, we have not been able to get Neography's method to work yet, I believe because Neo4j requires a secret key to clean the database (and Neography provides no instructions for configuring that secret key). Instead, we use HTTParty to send a delete message to Neo4j running at port 7475. The secret key we have decided to use is `xyzzy`, and you must configure Neo4j yourself to accept this key for the database delete. Instructions for how to do this are below, in the multiple server instances installation instructions.

## 17.1.4. Multiple Server instances on one machine (copied from the latter link)

Neo4j can be set up to run as several instances on one machine, providing for instance several databases for development. To configure, install two instances of the Neo4j Server in two different directories following the steps outlined below.

### First instance

First, create a directory to hold both database instances, and unpack the development instance:
```
cd $INSTANCE_ROOT
mkdir -p neo4j
cd neo4j
tar -xvzf /path/to/neo4j-community.tar.gz
mv neo4j-community dev
```

Next, configure the instance by changing the following values in dev/conf/neo4j-server.properties, see even Section 24.1, “Securing access to the Neo4j Server”:

```
org.neo4j.server.webserver.port=7474

# Uncomment the following if the instance will be accessed from a host other than localhost.
org.neo4j.server.webserver.address=0.0.0.0
```

Before running the Windows install or startup, change in dev/conf/neo4j-wrapper.properties

```
# Name of the service for the first instance
wrapper.name=neo4j_1
```

Start the instance:

```
dev/bin/neo4j start
```

Check that instance is available by browsing to `http://localhost:7474/webadmin/#`

### Second instance (testing, development)

In many cases during application development, it is desirable to have one development database set up, and another against which to run unit tests. For the following example, we are assuming that both databases will run on the same host.

Now create the unit testing second instance:

```
cd $INSTANCE_ROOT/neo4j
tar -xvzf /path/to/neo4j-community.tar.gz
mv neo4j-community test
```

It’s good practice to reset the unit testing database before each test run. This capability is not built into Neo4j server, so install a server plugin that does this:

```
wget http://github.com/downloads/jexp/neo4j-clean-remote-db-addon/test-delete-db-extension-1.4.jar
mv test-delete-db-extension-1.4.jar test/plugins
```

Next, configure the instance by changing the following values in test/conf/neo4j-server.properties to

change the server port to 7475
activate the clean-database server extension for remote cleaning of the database via REST

```
# Note the different port number from the development instance
org.neo4j.server.webserver.port=7475
 
# Uncomment the following if the instance will be accessed from a host other than localhost
org.neo4j.server.webserver.address=0.0.0.0
 
# Add the following lines to the JAXRS section at the bottom of the file
org.neo4j.server.thirdparty_jaxrs_classes=org.neo4j.server.extension.test.delete=/db/data/cleandb
org.neo4j.server.thirdparty.delete.key=secret-key
```

Note that secret key should be set to `xyzzy` for this application.

