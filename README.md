# lita-docker-hub

[![Build Status](https://travis-ci.org/datacite/lita-docker-hub.svg?branch=master)](https://travis-ci.org/datacite/lita-docker-hub)
[![Gem Version](https://badge.fury.io/rb/lita-docker-hub.svg)](https://badge.fury.io/rb/lita-docker-hub)

A [Docker Hub](https://hub.docker.com/) plugin for [Lita](https://www.lita.io/).

## Installation

Add lita-docker-hub to your Lita instance's Gemfile:

``` ruby
gem "lita-docker-hub"
```
## Configuration

You can configure the room where `lita-docker-hub` sends messages. The default is `general`.

```
Lita.configure do |config|
  config.handlers.docker_hub.room = "ops"
end
```

Make sure that the Lita bot is a member of this room.

## Usage

In Docker Hub go to the repository that you want to connect with Lita. You should have admin access to the Docker Hub configuration, and it should be an autobuild repository (builds triggered by Github or Bitbucket commits). Open the *Webhooks* tab of the repository and add the following URL:

```
http://MY_LITA_SERVER/docker-hub/receive
```

Where `MY_LITA_SERVER` is the name or IP address of your Lita server. Make sure the Lita server is accessible for web requests.

![Screenshot](https://raw.githubusercontent.com/datacite/lita-docker-hub/master/screenshot.png)

## License

[MIT](LICENSE.md)
