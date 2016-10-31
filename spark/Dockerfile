FROM islammohamedabdelaziz/ocono-hadoop
MAINTAINER Ocono islam.abdelaziz@ocono.de

USER root
RUN apt-get install vim python scala  -y
#support for Hadoop 2.6.0
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-2.0.0-bin-hadoop2.7.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-2.0.0-bin-hadoop2.7 spark
ENV SPARK_HOME /usr/local/spark
RUN mkdir $SPARK_HOME/yarn-remote-client
ADD yarn-remote-client $SPARK_HOME/yarn-remote-client

RUN $BOOTSTRAP && $HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave && $HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME-2.0.0-bin-hadoop2.7/jars /spark

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin


RUN mkdir -pv $HADOOP_COMMON_HOME/dfs/name
RUN mkdir -pv $HADOOP_COMMON_HOME/dfs/data
RUN mkdir -pv $HADOOP_COMMON_HOME/tmp

# update boot script
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]

# Spark ports
EXPOSE 4040
