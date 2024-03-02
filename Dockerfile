FROM ruby:3.1.3

# update apt
RUN apt update

# install packages
RUN apt install -y git wget unzip gnupg

# set up chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# download chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install -y ./google-chrome-stable_current_amd64.deb/

# Set up chromedriver environment variables
ENV CHROME_VERSION 122.0.6261.69
ENV CHROMEDRIVER_DIR /chromedriver
RUN mkdir $CHROMEDRIVER_DIR

# download and install chromedriver
RUN wget -q --continue -P $CHROMEDRIVER_DIR "https://storage.googleapis.com/chrome-for-testing-public/$CHROME_VERSION/linux64/chromedriver-linux64.zip"
RUN unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR
RUN mv /chromedriver/chromedriver*/chromedriver /usr/local/bin

# switch to project directory
WORKDIR /singdollar_server

# copy Gemfile and Gemfile.lock into image
COPY ./Gemfile* .

# install gems
RUN bundle install

# copy source code into image
COPY . .

RUN gem install foreman

CMD ["foreman", "start"]

EXPOSE 5000
