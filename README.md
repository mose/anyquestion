# AnyQuestion

This is a web app for managing the step "Do you have any question?" that happens at the end of a talk. It's inspired by a feature present in [Daskit](https://www.daskit.com/) which is not open source (yet?). Every talk has a room, people ask questions there and vote on other people questions. Then it gets easy for the speaker to select the question with the more weight.

There is a test install on http://anyquestion.herokuapp.com/ . As the data are not persisted, it's reset when the dyno goes to sleep.

## Usage

Code is not finished yet. but you can launch with:

    shards install

    # dev
    crystal src/anyquestion.cr

    # prod
    crystal build --release src/anyquestion.cr
    ./anyquestion -e production

    # deploy on heroku
    heroku create appname --buildpack https://github.com/crystal-lang/heroku-buildpack-crystal.git
    heroku git:remote -a appname
    git push heroku master

## dev links

- http://crystal-lang.org/docs/installation/index.html
- http://crystal-lang.org/docs
- http://crystal-lang.org/api
- http://kemalcr.com/

## Todo

- <s>debug react/kemal for it to refresh always, for now sometimes it doesn't refresh after new question</s>
- add a config file/env vars system
- make a debian package (and redhat maybe, see https://github.com/waghanza/plunder)
- add an admin account for editing things and cleaning up (oauth2 to github probably)
- consider an admin action to dump existing set of questions in case of restart
- add a possibility to cancel an upvote
- use fibers (`spawn`) to handle websockets maybe
- expose some api endpoints for plugging irc/slack bots into this
- check responsivity

## Contributing

- fork it, twist it, submit a PR.

## License

Copyright (c) 2016 mose - MIT license

## Contributors

- [mose](https://github.com/mose) - author
