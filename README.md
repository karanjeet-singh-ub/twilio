# twilio

Rails application to:

1. point a Twilio phone and play FizzBuzz; production env validates the  X-Twilio-Signature header.
2. interface to enter a phone number (Twilio), gather a number and play FizzBuzz
3. interface delay + step 2

built on ruby 2.2; rails 4.2

Running the app:

Pre-requirements:
 1. ngrok - to deploy on the internet; https://ngrok.com/
 2.  redis-server; sudo apt-get install redis-server

commands are:
 1.  bundle install
 2.  rails s
 3.  redis-server (in a separate terminal)
 4.  bundle exec sidekiq (in a separate terminal)
 5.  ./ngrok http 3000 ( in a separate terminal)

now that the webapp is hosted publically, we can use the url at Twilio
we configure the app now.

config.application.rb holds:

1. Twilio number (config.twilio_number)
2. host_url (config.host_url); same to be used in the Twilio account for calls. this the ngrok hosted url.
3. twilio account sid, auth token are in config/secrets.yml

url for phase 1 is <hostname:port>/ivr/welcome
url for phase 2 and 3 is the default page.

After filling in the config parameter, we run the app in production mode:

rails s -e production

