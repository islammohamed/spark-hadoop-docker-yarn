#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -


# setting spark defaults
echo spark.yarn.jars hdfs:///spark/spark-yarn_2.11-2.0.0.jar > $SPARK_HOME/conf/spark-defaults.conf
cp $SPARK_HOME/conf/metrics.properties.template $SPARK_HOME/conf/metrics.properties

/etc/init.d/ssh start

echo "datanode01
datanode02
datanode03
 " > $HADOOP_PREFIX/etc/hadoop/slaves


cp $HADOOP_PREFIX/etc/hadoop/slaves $SPARK_HOME/conf/slaves

cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh

echo "
export SPARK_MASTER_IP=spark
export SPARK_MASTER_PORT=7077
export SPARK_WORKER_MEMORY=1g
export MASTER=spark://spark:7077" >> $SPARK_HOME/conf/spark-env.sh

if [[ $1 = "-namenode" || $2 = "-namenode" ]]; then
  #$HADOOP_PREFIX/bin/hdfs namenode -format -Y -f
  $HADOOP_PREFIX/sbin/start-dfs.sh
  $HADOOP_PREFIX/sbin/start-yarn.sh
fi

if [[ `echo $1 | grep "datanode"` || `echo $2 | grep "datanode"` ]]; then
    echo 'starting datanode ';
    while true; do sleep 1000; done
fi

if [[ $1 = "-d" || $2 = "-d" ]]; then
  $SPARK_HOME/sbin/start-all.sh
  while true; do sleep 1000; done
fi

if [[ $1 = "-bash" || $2 = "-bash" ]]; then
  /bin/bash
fi
