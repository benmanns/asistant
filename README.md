# asistant

This program automatically attempts to register for classes through Liberty University's ASIST system every 10-15 seconds.

## Running the Program

To run the program, download it with git:

    git clone git://github.com/benmanns/asistant.git

Enter the program directory:

    cd asistant

Install the required gems:

    bundle install

Finally, configure and run the program using environment variables:

    LIBERTY_USERNAME=sparky LIBERTY_PASSWORD=flames LIBERTY_TERM="Spring 2013" LIBERTY_CRNS=12345 ruby asistant.rb

## Running on Heroku

This program is also Heroku compatible. To run on Heroku, download the program:
    git clone git://github.com/benmanns/asistant.git

Enter the program directory:

    cd asistant

Create a Heroku application:

    heroku create

Add your configuration variables to Heroku:

    heroku config:add LIBERTY_USERNAME=sparky LIBERTY_PASSWORD=flames LIBERTY_TERM="Spring 2013" LIBERTY_CRNS=12345

Push the application:

    git push heroku master

Scale a worker process:

    heroku scale worker=1

Monitor progress:

    heroku logs --tail | grep Result:

## Configuration Variables

There are four environment variables used for configuration of this program.

### LIBERTY_USERNAME

your liberty.edu username.

### LIBERTY_PASSWORD

your liberty.edu password.

### LIBERTY_TERM

the term you are registering for. This is the text value of the dropdown box when you select a term while navigating to the Add/Drop form. For example: `"Spring 2013"`.

### LIBERTY_CRNS

a comma-separated list of the classes you wish to register for. This value is obtained by looking at the course catalog, and is specific to the term, subject, class number, and section number. If you only wish to register for one class, simply use the class CRN. For multiple classes, use the format `"12345,56789"`.

## Single Session Requirement

Liberty's ASIST only allows one active session per user, so if you want to login to your account, you will need to stop the asistant instance. Running locally, you can stop the program by interrupting with `CTRL+C`. To stop the program on Heroku, run `heroku scale worker=0`.
