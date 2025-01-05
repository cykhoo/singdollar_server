FROM ruby:3.4.1

# update apt and install packages
RUN apt update && apt install -y wget unzip

# Set up chromedriver environment variables
ENV CHROME_VERSION=131.0.6778.205
ENV CHROMEDRIVER_DIR=/chromedriver

# download and install chromedriver
RUN mkdir $CHROMEDRIVER_DIR
RUN wget -q --continue -P $CHROMEDRIVER_DIR "https://storage.googleapis.com/chrome-for-testing-public/$CHROME_VERSION/linux64/chromedriver-linux64.zip"
RUN wget -q --continue -P $CHROMEDRIVER_DIR "https://storage.googleapis.com/chrome-for-testing-public/$CHROME_VERSION/linux64/chrome-linux64.zip"

RUN unzip $CHROMEDRIVER_DIR/chromedriver-linux64.zip -d $CHROMEDRIVER_DIR
RUN unzip $CHROMEDRIVER_DIR/chrome-linux64.zip -d $CHROMEDRIVER_DIR

RUN mv $CHROMEDRIVER_DIR/chromedriver-linux64/chromedriver /usr/local/bin
RUN mv $CHROMEDRIVER_DIR/chrome-linux64/chrome /usr/local/bin

# switch to project directory
WORKDIR /singdollar_server

# copy Gemfile and Gemfile.lock into image
COPY ./Gemfile* .

# install gems
RUN bundle install

# copy source code into image
COPY . .

RUN gem install foreman

CMD ["RACK_ENV=production", "foreman", "start"]

EXPOSE 4000
