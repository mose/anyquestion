# AnyQuestion

This is a web app for managing the step "Do you have any question?" that happens at the end of a talk. It's inspired by a feature present in [Daskit](https://www.daskit.com/) which is not open source (yet?). Every talk has a room, people ask questions there and vote on other people questions. Then it gets easy for the speaker to select the question with the more weight.

There is a test install on http://anyquestion.herokuapp.com/ . As the data are not persisted, it's reset when the dyno goes to sleep.

**Warning**: this piece of code is designed for a specific use case that doesn't require high security bu just a tool for quick and dirty polling on questions after talks. It has not been tested at scale, and its security setup is quite minimal.

## Usage

You have been to conferences, right? Every time at then end, there is some time for the questions. But sometimes people are shy, or there is some mike issue, or people are not native speaker and their strong accent prevent everybody to understand what they ask.

Make this web app reachable for you attendees. They can add questions during the talk, so there is no way to forget them. They can upvote the questions of other people. They also can cancel their own upvotes if they change their minds or if the speaker answered the question before it was asked, in the progress of his talk. Questions that reach zero vote will just disappear.

Typically, at the end, the speaker or someone else can access the questions, pick in the ones that are the most popular and read them. The speaker can then answer them.

## Dev

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

Check the [CHANGELOG.md](CHANGELOG.md) file for details.

- <s>debug react/kemal for it to refresh always, for now sometimes it doesn't refresh after new question</s>
- <s>add a possibility to cancel an upvote</s>
- <s>add a config file/env vars system</s>
- <s>add an admin account for editing things and cleaning up (oauth2 to github probably)</s>
- <s>consider an admin action to dump existing set of questions in case of restart (export/import)</s>
- make a debian package (and redhat maybe, see https://github.com/waghanza/plunder)
- use fibers (`spawn`) to handle websockets maybe
- expose some api endpoints for plugging irc/slack bots into this
- check responsivity


## Contributing

- fork it, twist it, submit a PR.

## License

Copyright (c) 2016 mose - MIT license

## Contributors

- [mose](https://github.com/mose) - author
