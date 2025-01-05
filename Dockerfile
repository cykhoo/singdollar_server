FROM ruby:3.4.1

# update apt
RUN apt update

# install packages
RUN apt install -y git wget unzip gnupg

# add key to keyring
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | \
    tee /usr/share/keyrings/google-archive-keyring.gpg > /dev/null

# add repository as source
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/google-archive-keyring.gpg] \
    https://dl.google.com/linux/chrome/deb/ stable main" | \
    tee /etc/apt/sources.list.d/google-chrome.list

# update apt and install google chrome
RUN apt update
RUN apt install -y google-chrome-stable

# Set up chromedriver environment variables
ENV CHROME_VERSION 131.0.6778.86
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

EXPOSE 4000
