AvFacts -- Aviation knowledge without limits
============================================

This website is the home of AvFacts, a podcast about aviation. The website
allows the admin (that's me!) to upload new episodes, transcodes those episodes,
publishes an RSS feed for podcast readers to consume, and displays a web page
where viewers can browse and listen to past episodes.

Requirements and Technologies
-----------------------------

AvFacts is a Ruby on Rails back-end and Vue.js front-end. The back-end handles
uploading, transcoding, and publishes JSON and RSS APIs. The front-end displays
the web pages hosted at avfacts.org. The two are managed together using
Webpacker.

A pre-release version of Rails 5.2 is used to take advantage of Active Storage,
which handles file uploading and storage. FFMPEG is used to perform the
transcoding, and MiniMagick to perform image processing.

AvFacts uses PostgreSQL 10 as its database (including fulltext search). In
production, offline jobs are handled by Sidekiq and caching by Redis. Node.js
is used to compile and serve the JavaScript-based front-end.

### Running the server

To run the back-end server and front-end Webpack client in development mode, use
the provided Procfile. Install the foreman gem and run `foreman start` in the
application directory to run both processes. The back-end server also handles
job processing in development.

Architecture
------------

### Models and transcoding

AvFacts has only two models, {User} (representing an admin user who can upload
and edit episodes), and {Episode}, representing a podcast episode.

The Episode model has two attached files via Active Storage: `audio` and
`image`. A custom {Transcode} class is used to produce transcoded variants of
the audio file. The {AudioAnalyzer} class is a custom Active Storage analyzer
that determines the duration of each episode. Patch code in
`config/initializers/transcode.rb` provides for (a) storage and retrieval of
transcoded variants of audio files, and (b) an internal controller, similar to
other Active Storage controllers, that streams transcoded files to the user,
and supports Range queries for podcasting software.

The `config/initializers/thumbnails.rb` file adds an image variant that produces
scaled and cropped thumbnail images.

### Controllers and authentication

The RESTful controllers provide JSON views that power the Vue.js front-end, and
an RSS format for podcast readers. Formats are discriminated using
`respond_to`/`respond_with`.

Authentication is handled by the User model. Any user with an account is an
admin. A JSON-based API controller receives valid credentials and creates a
session Rails's standard encrypted session storage. A unique token is then
generated also saved in the encrypted session, and returned to the front-end.
The front-end uses this token as "proof" that a login has occurred.

### Front-end

The front-end is a Vue.js single-page application. Vue-Router is used to handle
routes and history, and Vuex handles local state.

The {HomeController#index} action is a catch-all action that responds to all
unrecognized requests. The action merely renders the basic structure of the web
page and initialized Vue.js. Vue-Router then parses the URL and determines which
Vue template to render into the page structure.

The Vuex store is in `app/frontend/store` and stores episode and session
information, and has methods to request such information from the back-end when
it is not stored locally.

Two global Vue components are defined in `app/frontend/components`: A Lightbox
component that displays a lightbox atop an overlay, and a `SmartForm` component
that works similarly to Rails's `form_for`. (Using the associated `SmartField`
component, one can generate a form that is linked to a model object.)

All views are in `app/frontend/views` and are organized by the routes defined at
`app/frontend/routes.js`. CSS and image assets, along with all JavaScript, is
compiled by Webpacker. The only Webpacker entry file is at
`app/frontend/packs/application.js`, which initializes the Vue app and includes
all other JS and CSS assets. Also in the `packs` directory is the `logo.png`
file, which is hosted for external use as the podcast logo.

CSRF protection is handled using the normal Rails request forgery protection
tokens. They are passed as `META` tags to the front-end and an axios injector
in `app/frontend/config/addCSRFTokens.js` inserts them as request headers for
every request to the backend. JSON requests without the proper tokens are
rejected.

Documentation
-------------

YARD documentation is provided for the back-end. To compile it, run `rake yard`
in the root directory. The generated HTML documentation will be in the `doc/app`
directory.

Specs
-----

Controllers, models, and library files are tested using RSpec. Run `rspec spec`
to run all back-end tests.

Secrets
-------

Secrets are managed using Rails. The `config/credentials.yml.enc` stores
encrypted secrets like the Amazon Web Services keys. The correct
`config/master.key` file must be present to access those secrets.

TODO
----

* Audio/image file type validation
* Audio/image file size validation
* Image dimensions validation
