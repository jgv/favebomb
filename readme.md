# Favebomb

Hello! Have you ever released a project on the "internet" and wanted to high five people who are tweeting about it?? It's super annoying to fave each and every tweet. **Enter Favebomb** This little Ruby gem will take care of all your faving for you!

## Installation

Currently Favebomb requires that you [create a Twitter app](https://dev.twitter.com/apps/new) and have environment variables for the consumer and OAuth tokens. Add something like this to your config:

``` bash
export FAVEBOMB_CONSUMER_KEY=12345
export FAVEBOMB_CONSUMER_SECRET=12345
export FAVEBOMB_ACCESS_TOKEN=12345
export FAVEBOMB_ACCESS_SECRET=12345
```

Then actually install Favebomb like so:

``` bash
$ gem install favebomb
```
or in your Gemfile: `gem 'favebomb'`

## Usage

```
$ favebomb --help

Usage: favebomb [command] [options]
    -l, --lang lang                  Restricts tweets to the given language, given by an ISO 639-1 code.
                                     Language detection is best-effort.
    -t, --type type                  Restrict tweets to a specific type. Choose between popular, recent,
                                     or mixed (the default).
    -c, --count count                Control the number of tweets to fave. Maximum is 100, default is 15.
    -u, --until date                 Returns tweets generated before the given date. Date should be
                                     formatted as YYYY-MM-DD. Keep in mind that the search index may not
                                     go back as far as the date you specify here.
    -g, --geocode code               Returns tweets by users located within a given radius of the given
                                     latitude/longitude. The location is preferentially taking from the
                                     Geotagging API, but will fall back to their Twitter profile. The
                                     parameter value is specified by 'latitude,longitude,radius', where
                                     radius units must be specified as either 'mi' (miles) or 'km'
                                     (kilometers). Note that you cannot use the near operator via the API
                                     to geocode arbitrary locations; however you can use this geocode
                                     parameter to search near geocodes directly. A maximum of 1,000
                                     distinct 'sub-regions' will be considered when using the radius
                                     modifier.
    -h, --help                       Show this message

```

The [Twitter search docs](https://dev.twitter.com/docs/api/1.1/get/search/tweets) are also a good resource for option usage.

Let's search Twitter for the term "bieber" and fave a bunch of Tweets.

``` bash
$ favebomb bieber
```

Or what about searching Twitter for "kawaii" from users located in Japan.

``` bash
$ favebomb --lang ja kawaii
```

## Tests

Run tests with minitest.

```
$ ruby test/unit/favebomb.rb
```

**License: MIT**

![Biz](http://cl.ly/image/0y3G3Q2W3J3A/Screen%20Shot%202013-02-19%20at%203.16.09%20PM.png!)

