Druid (Docker + Kubernetes)
===========================

Tags:

- latest ([Dockerfile](https://github.com/airtimetv/druid-docker/blob/master/Dockerfile))

Druid Version: 0.15.1-incubating

**Warning**

This repository is under development. It has *not* been battle tested in a production environment yet. Use at your own risk.

What is Druid?
==============

Druid is an open-source analytics data store designed for business intelligence (OLAP) queries on event data. Druid provides low latency (real-time) data ingestion, flexible data exploration, and fast data aggregation. Existing Druid deployments have scaled to trillions of events and petabytes of data. Druid is most commonly used to power user-facing analytic applications.

External Requirements
=====================
- [x] [Zookeeper](https://github.com/helm/charts/tree/master/incubator/zookeeper)

Services
========
- Broker:8082
- Coordinator:8081
- Historical:8083
- MiddleManager:8091
- Overlord:8090
- Router:8080
- Postgres:5432

Configuration
=============

Available environment options:

- `ZOOKEEPER_HOST` '-'
- `DRUID_XMX` '-'
- `DRUID_XMS` '-'
- `DRUID_MAXNEWSIZE` '-'
- `DRUID_NEWSIZE` '-'
- `DRUID_LOGLEVEL` '-'
- `DRUID_USE_CONTAINER_IP` '-'
- `DB_TYPE` 'postgresql'
- `DB_HOST` 'postgres'
- `DB_PORT` '5432'
- `DB_DBNAME` 'druid'
- `POSTGRES_USER` 'postgres'
- `POSTGRES_PASSWORD` 'keepasecret'
- `POSTGRES_HOST` 'localhost'
- `POSTGRES_PORT` '5432'

Fixed Features
==============
- [x] Kafka Indexing Service


Disabled Features
=================
- S3 Deep Storage


Docker Deployment
=================
`docker-compose up`

Docker Development
=================

Build the container Image:

`docker build -t airtimetv/druid-docker:latest .`


Push the image to docker.io:

`docker push airtimetv/druid:latest`


Kubernetes Deployment
=====================

The Kubernetes deployment `druid-deployment.yaml` has only been tested on GCP.

Create the cluster:

```
gcloud container clusters create druid --machine-type n1-highmem-2

kubectl apply -f druid-deployment.yaml

kubectl delete -f druid-deployment.yaml
```


TODO
====
- [ ] Restrict kubernetes port access
- [ ] Allow JVM configuration variables to be passed in as environment variables
- [ ] Tune JVM Memory configuration for a production environment
- [ ] Enable additional druid features through config variables
