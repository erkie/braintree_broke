FROM phusion/passenger-ruby24

ENV HOME /root
ENV app /home/app

HEALTHCHECK CMD curl --fail http://localhost/ || exit 1

CMD ["/sbin/my_init"]

EXPOSE 80
EXPOSE 443

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install --without staging development test deploy --jobs 8

WORKDIR $app
COPY . $app

RUN mv /tmp/Gemfile* /tmp/.bundle $app/

RUN mkdir -p $app/public/system && \
  mkdir -p $app/tmp && \
  rm /etc/nginx/sites-enabled/default && \
  rm -f /etc/service/nginx/down && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* $app/.git

RUN chown -R app:app /home/app && \
  chmod -R 0755 /home/app

ADD hosting/nginx/sites-enabled/site.conf /etc/nginx/sites-enabled/site.conf
