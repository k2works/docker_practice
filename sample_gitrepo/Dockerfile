FROM ubuntu

# Install basic dev tools
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    curl \
    git

# Install package for ruby
RUN apt-get install -y \
    zlib1g-dev \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libxml2-dev \
    libxslt-dev

# Install package for sqlite3
RUN apt-get install -y \
    sqlite3 \
    libsqlite3-dev

# Install package for postgresql
RUN apt-get install -y libpq-dev

# Install rvm
RUN curl -L https://get.rvm.io | bash -s stable
RUN echo 'source /usr/local/rvm/scripts/rvm' >> /etc/profile.d/rvm.sh
RUN echo 'source /usr/local/rvm/scripts/rvm' >> .bashrc

# Install multiple versions of ruby
ENV PATH /usr/local/rvm/bin:$PATH
RUN rvm install --disable-install-doc 2.0.0-p247

# Install Bundler for each version of ruby
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN bash -l -c 'rvm use 2.0.0-p247; gem update; gem install bundler'
# Add Application
RUN mkdir /myapp
WORKDIR /myapp
ADD .rbdock_app/Gemfile /myapp/Gemfile
ADD .rbdock_app/classic /myapp
RUN bash -l -c 'rvm use 2.0.0-p247; bundle install'

ENTRYPOINT ["bash", "-l", "-c"]
