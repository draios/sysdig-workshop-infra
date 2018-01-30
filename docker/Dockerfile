FROM ubuntu:17.10

RUN apt-get update && apt-get install -y ruby git curl && \
	gem install bundler && \
	curl -O https://packages.chef.io/files/stable/chefdk/2.4.17/ubuntu/16.04/chefdk_2.4.17-1_amd64.deb && \
	dpkg -i chefdk_2.4.17-1_amd64.deb && rm -f chefdk_2.4.17-1_amd64.deb

RUN git clone https://github.com/mfdii/sysdig_workstation

WORKDIR sysdig_workstation

RUN rm -f Gemfile.lock && \
	bundle install && rake cookbook:vendor

CMD ["rake"]