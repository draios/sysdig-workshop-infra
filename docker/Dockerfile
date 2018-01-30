FROM ubuntu:17.10

RUN apt-get update && apt-get install -y ruby git && \
	gem install bundler 

RUN git clone https://github.com/mfdii/sysdig_workstation

WORKDIR sysdig_workstation

RUN rm -f Gemfile.lock && \
	bundle install && rake cookbook:vendor

CMD ["rake"]