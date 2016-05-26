Greetings,

Thanks for checking out this repository. You will find here an easy-to-use Docker image to launch a single-node Kaa server in just a few clicks.
If you don't know about Kaa, check out their home page: http://www.kaaproject.org.

![](http://www.kaaproject.org/wp-content/themes/jupiter/images/logo-kaa-with-eyebrows-01.svg?cd593a)

"Kaa is a feature-rich, open-source IoT middleware platform for rapid development of the Internet of Things solutions, IoT applications, and smart products."

## Installation requirements

We suggest you first checkout Kaa's official installation guide before using this image:

-> http://docs.kaaproject.org/display/KAA/Installation+guide

In order to use this image, you will need to provide the following:

- Zookeeper 3.4.5
- PostgreSQL 9.4 OR MariaDB 5.5 <b>(0.9+ only!)</b>
- MongoDB 2.6.9 OR Cassandra 2.2.5

Note that we have not tested this image with Cassandra, but environment variables are all available. Contributions via pull-requests are highly appreciated!

## Quick run

0. Download Kaa's debian packages at: http://www.kaaproject.org/download-kaa/ and place them inside 'install/deb/'

1. Run PostgreSQL/MariaDB, Zookeeper and MongoDB/Cassandra

2. Build this image (build.sh for your convenience)

3. Write up a Docker environment file to configure your server, see example-env.dockerenv. (Don't expose sensitive data in your command line!)

4. Run image, link the containers your preferred way (docker network works great!). See 'docker-run-kaa-0.9.sh' for an example.

## Logs

If you run your Docker container as a daemon, you won't see its output. That's okay, just run:

$ docker exec <container-name> tail -f /var/log/kaa/kaa-node.log

Or simply run the shortcut script 'view-kaa-node-logs.sh' !


## Notes

This image was originally written to ease deployment and testing. If you find any bugs or misplaced stuff, help us tidy-up with a pull request!


--
Maintainer: Christopher Burroughs,
lead software engineer & architect at xMight Inc., an IoT startup.
