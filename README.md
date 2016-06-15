# AnyQuestion

This is a web app for managing the step "Do you have any question?" that happens at the end of a talk. It's inspired by a feature present in [Daskit](https://www.daskit.com/) which is not open source (yet?). Every talk has a room, people ask questions there and vote on other people questions. Then it gets easy for the speaker to select the question with the more weight.

## Usage

Code is not finished yet. but you can launch with:

    shards install

    # dev
    crystal src/anyquestion.cr

    # prod
    crystal build --release src/anyquestion.cr
    ./anyquestion -e production

    # deploy (embedding all libs for portability)
    crystal build src/anyquestion.cr --release --link-flags "-static -L/opt/crystal/embedded/lib"

## dev links

- http://crystal-lang.org/docs/installation/index.html
- http://kemalcr.com/
- http://crystal-lang.org/docs
- http://crystal-lang.org/api

## Contributing

- fork it, twist it, submit a PR.

## License

Copyright (c) 2016 mose - MIT license

## Contributors

- [mose](https://github.com/mose) - author
