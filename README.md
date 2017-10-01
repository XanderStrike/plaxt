# Plaxt

A simple webhooks based scrobbler to sync your Plex plays with Trakt

I'm hosting it myself at [plaxt.herokuapp.com](http://plaxt.herokuapp.com), feel free to use this instance, it will always be updated with the latest and greatest.

If you'd like to host it yourself to avoid exposing your plays to me, you can host it yourself on Heroku by clicking the button below:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

You'll need to create your own API app set up the CLIENT_ID and CLIENT_SECRET env variables on your heroku instance. You will get `The redirect uri included is not valid.` from Trakt if you don't.

You can also host it anywhere you can normally host Rails apps.
