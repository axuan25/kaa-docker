Greetings, and thanks for checking out this repository. You will find here an easy-to-use Docker image to launch a single-node Kaa server in just a few clicks.
If you don't know about Kaa, check out their home page: http://www.kaaproject.org.

![](http://www.kaaproject.org/wp-content/themes/jupiter/images/logo-kaa-with-eyebrows-01.svg?cd593a)

"Kaa is a feature-rich, open-source IoT middleware platform for rapid development of the Internet of Things solutions, IoT applications, and smart products."

<hr />

I suggest you first checkout Kaa's official installation guide before using this image:

-> http://docs.kaaproject.org/display/KAA/Installation+guide

Kaa IoT requires the following dependencies to run:

- Zookeeper 3.4.5
- MariaDB 5.5 <b><i>or</i></b> PostgreSQL 9.4
- MongoDB 3.2.6 <b><i>or</i></b> Cassandra 2.2.5

<i>It is recommended to use the versions specified above. Try later versions at your own risk!</i>

<u>Note:</u> <u>Anything within the "develop" branch of this repository has not yet been fully tested.</u>

<hr />

## Most recent updates:
<i>
- Added docker-compose examples for MariaDB and PostgreSQL
- Added script to wait for JDBC before starting kaa-node service
- Updated Dockerfile to include PostgreSQL driver
</i>

## Quick and <b>easy</b> run

I have provided two examples runs using docker-compose. Simply run <b>launch-laa.sh</b> in either:

<i>Using MariaDB + MongoDB:</i>
- examples/using-compose/<b>mariadb-mongodb</b>/

<i>Using PostgreSQL + MongoDB:</i>
- examples/using-compose/<b>postgresql-mongodb</b>/

Running a single command, you will easily deploy a single-node Kaa IoT server. <b><i>Unreleased:</b> easy cluster deployment!</i>

## Run-it-yourself (RIY)

Obtain the image in two ways:

<b>Docker hub (recommended)</b> 

cburr25/kaa:0.9.0

<b>Docker build</b>

1. Download Kaa's debian packages at: http://www.kaaproject.org/download-kaa/ and place them inside 'install/deb/'

2. Build this image (build.sh for your convenience)

Then follow these steps to run the image:

<b>(1)</b> Run Zookeeper (3.4.8), MariaDB (5.5)/PostgreSQL (9.4) and MongoDB (3.2.6)/Cassandra (2.2.5)

<b>(2)</b> Write up a Docker environment file to configure your server, see <i>examples/using-compose/kaa-example.env</i>

<u>List of available environment variables:</u>

| VARIABLE         		       	|   DEFAULT					| NOTE / POSSIBLE VALUES
| -----------------------------	|--------------------------	| ----------------------------
| ZOOKEEPER_NODE_LIST			| localhost:2181			| <i>comma separated list</i>
| 								| 							|
| SQL_PROVIDER_NAME				| <b>null: mandatory!</b>	| mariadb , postgresql
| JDBC_HOST						| localhost					|
| JDBC_PORT						| if mariadb: 3306<br>if postgresql: 5432 | 
| JDBC_USERNAME					| sqladmin					| 
| JDBC_PASSWORD					| admin						|
| JDBC_DB_NAME					| kaa 						| 
								| 							| 
| CASSANDRA_CLUSTER_NAME		| Kaa Cluster 				| 
| CASSANDRA_KEYSPACE_NAME		| kaa 						| 
| CASSANDRA_NODE_LIST			| localhost:9042 			| <i>comma separated list</i>
| CASSANDRA_USE_SSL				| false 					| 
| CASSANDRA_USE_JMX				| true 						| 
| CASSANDRA_USE_CREDENTIALS		| false 					| 
| CASSANDRA_USERNAME 			| (empty) 					| 
| CASSANDRA_PASSWORD 			| (empty) 					| 
| 								| 							| 
| MONGODB_NODE_LIST 			| localhost:27017 			| 
| MONGODB_DB_NAME				| kaa 						| 
| MONGODB_WRITE_CONCERN 		| acknowledged 				| 
| 								| 							| 
| NOSQL_DB_PROVIDER_NAME		| mongodb 					| mongodb , cassandra

<b>(3)</b> Run this image, link the containers however you want. <i>See 'docker-run-kaa-0.9.sh' for an example.</i>

<b><u>UPCOMING UPDATE:</u></b> A more complete set of examples will be included soon, including running with Cassandra and easy cluster deployment. <b>Watch out for updates!</b>

## Logs

If you run your Docker container as a daemon, you won't see its output. That's okay, just run:

$ docker exec <container-name> tail -f /var/log/kaa/kaa-node.log

Or simply run the shortcut script 'view-kaa-node-logs.sh' in the examples !

## Notes

This image was originally written to ease deployment and testing. If you find any bugs or misplaced stuff, help us tidy-up with a pull request!


--
Maintainer: Christopher Burroughs,
lead software engineer & architect at xMight Inc., an energy management IoT startup.
