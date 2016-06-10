Greetings,

Thanks for checking out this repository. You will find here an easy-to-use Docker image to launch a single-node Kaa server in just a few clicks.
If you don't know about Kaa, check out their home page: http://www.kaaproject.org.

![](http://www.kaaproject.org/wp-content/themes/jupiter/images/logo-kaa-with-eyebrows-01.svg?cd593a)

"Kaa is a feature-rich, open-source IoT middleware platform for rapid development of the Internet of Things solutions, IoT applications, and smart products."

## Installation requirements

I suggest you first checkout Kaa's official installation guide before using this image:

-> http://docs.kaaproject.org/display/KAA/Installation+guide

In order to use this image, you will need to provide the following dependencies:

- Zookeeper 3.4.5
- MariaDB 5.5 <i>OR</i> PostgreSQL 9.4
- MongoDB 2.6.9 OR Cassandra 2.2.5

<b>Note 1:</b> <i>It is highly recommended to use the versions specified above! No support will be provided if you decide to use their latest versions.</i>

<b>Note 2:</b> <i>I have not tested this image with Cassandra, but environment variables are all available. Contributions via pull-requests are highly appreciated!</i>

## Get the image

<b>Docker hub -></b> 

cburr25/kaa:0.9.0

<b>Docker build -></b>

0. Download Kaa's debian packages at: http://www.kaaproject.org/download-kaa/ and place them inside 'install/deb/'

1. Build this image (build.sh for your convenience)

## Quick run

<b>(1)</b> Run Zookeeper, MariaDB/PostgreSQL and MongoDB/Cassandra

<b>(2)</b> Write up a Docker environment file to configure your server, see example-env.dockerenv. Some available environment variables are:

| VARIABLE         		       	|   DEFAULT					| NOTE / POSSIBLE VALUES
| -----------------------------	|--------------------------	|
| ZOOKEEPER_NODE_LIST			| localhost:2181			| <i>comma separated list</i>
| 								| 							|
| SQL_PROVIDER_NAME				| <b>null: mandatory!</b>	| mariadb , postgresql
| JDBC_HOST						| localhost					|
| JDBC_PORT						| if mariadb: 3306<br>if postgresql: 5432 | 
| JDBC_USERNAME					| sqladmin					| 
| JDBC_PASSWORD					| admin						|
| JDBC_DB_NAME					| kaa 						| 
								| 
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

<b><u>UPCOMING UPDATE:</u></b> A more complete set of examples will be included soon, including different flavors of docker-compose files. Watch out for updates!

## Logs

If you run your Docker container as a daemon, you won't see its output. That's okay, just run:

$ docker exec <container-name> tail -f /var/log/kaa/kaa-node.log

Or simply run the shortcut script 'view-kaa-node-logs.sh' !

## Notes

This image was originally written to ease deployment and testing. If you find any bugs or misplaced stuff, help us tidy-up with a pull request!


--
Maintainer: Christopher Burroughs,
lead software engineer & architect at xMight Inc., an energy management IoT startup.
