# Rorschach

## Overview

Rorschach is a simple alerting tool that uses Graphite for event data. Rorschach takes Graphite metrics and sends out notifications based on pre-defined warning and critical thresholds. Notifications can (currently) be sent to Campfire, PagerDuty, and via email.

![](http://i.imgur.com/Gyvvt.png)

## Caveats

It's rough around the edges. I wrote this in an evening, so things might be out of place, wonky, or just wrong. Expect improvements to follow shortly.

## Dependencies

* Ruby >= 1.9.2
* PostgreSQL
* Redis

Rorschach uses PostgreSQL to store check data. [Sidekiq](https://github.com/mperham/sidekiq) is used for scheduling checks in the background, and uses Redis for its backend storage.

## Configuration

Rorschach uses the following environment variables for configuration:

* `GRAPHITE_URL` - Graphite server URL
* `GRAPHITE_AUTH` - Basic HTTP auth credentials (optional)
* `CAMPFIRE_TOKEN` - Campfire API token
* `CAMPFIRE_ACCOUNT` - Campfire account name
* `CAMPFIRE_ROOM` - The room to which notifications will be sent
* `PAGERDUTY_API_KEY` - PagerDuty API key

## Deployment

Rorschach is designed to be easily deployed to [Heroku](http://heroku.com). Nonetheless, deployment to your preferred provider should be as simple as any other Ruby application.

### Heroku

```bash
heroku create -s cedar
heroku addons:add heroku-postgresql:dev
heroku addons:add redistogo
heroku config:set GRAPHITE_URL=[...]
heroku config:set GRAPHITE_AUTH=[...]
heroku config:set CAMPFIRE_ACCOUNT=[...]
heroku config:set CAMPFIRE_ROOM=[...]
heroku config:set CAMPFIRE_TOKEN=[...]
heroku config:set PAGERDUTY_API_KEY=[...]
git push heroku master
heroku scale web=1
heroku scale worker=1
```

## TODO

* Schedule all checks on startup
* Allow checks to be paused
* Actually send to PagerDuty
* Customize per-check handlers