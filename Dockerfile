FROM ruby:3.1.3

# update apt
RUN apt update

# install packages
RUN apt install -y git wget unzip gnupg

# add key to keyring
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | \
    tee /usr/share/keyrings/google-archive-keyring.gpg > /dev/null

# download chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install -y ./google-chrome-stable_current_amd64.deb/
# add repository as source
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/google-archive-keyring.gpg] \
    https://dl.google.com/linux/chrome/deb/ stable main" | \
    tee /etc/apt/sources.list.d/google-chrome.list


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
