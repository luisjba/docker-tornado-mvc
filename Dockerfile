FROM python:3.7

WORKDIR /home/app
ARG TORNADO_MVC_SRC_TARGET=/home/src_tornado-mvc
COPY scripts/init_container.sh /tmp/
COPY scripts/install_tornado_mvc.sh /tmp/

#package needed for Tornado-MVC
RUN apt-get update && apt-get install -y \
openssl ca-certificates gcc locales rsyslog \
&& echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
&& locale-gen \
&& pip install --upgrade pip \
&& chmod +x /tmp/*.sh

RUN chmod +x /tmp/*.sh \
&& mv /tmp/init_container.sh /usr/local/bin/init_container \
&& sync

RUN echo "Installing Tornado-MVC" \  
&& /tmp/install_tornado_mvc.sh $TORNADO_MVC_SRC_TARGET \
&& sync

EXPOSE 8080

ENV TORNADO_MVC_APP /home/app
ENV PORT 8080
ENV PIP_INSTALL_REQUIREMENTS ""
WORKDIR $TORNADO_MVC_APP
ENTRYPOINT ["init_container"]
CMD ["python", "app.py", "-p $PORT"]