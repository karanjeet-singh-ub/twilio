# twilio

Rails application to:

1. point a Twilio phone and play FizzBuzz; production env validates the  X-Twilio-Signature header.
2. interface to enter a phone number (Twilio), gather a number and play FizzBuzz
3. interface delay + step 2

built on ruby 2.2; rails 4.2

config.application.rb holds:

1. Twilio number (config.twilio_number)
2. host_url (config.host_url); same to be used in the Twilio account for calls.

application can be launched and deployed on ngork at the same port ./ngrok http 3000
url for phase 1 is <hostname:port>/ivr/welcome
url for phase 2 and 3 is the default page.

twilio account sid, auth token are in config/secrets.yml
