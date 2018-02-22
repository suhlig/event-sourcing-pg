# Experiments with Event Sourcing

based on:

* https://medium.com/@tobyhede/event-sourcing-with-postgresql-28c5e8f211a2
* https://github.com/tobyhede/postgresql-event-sourcing/blob/master/README.md
* https://gist.github.com/janko-m/87865c47500a90302152#file-02-sequel-rb
* https://vaughnvernon.co/?p=942

# Setup

```bash
bundle install
dropdb event_sourcing_test; createdb event_sourcing_test; rake db:migrate
```

# Development

```bash
bundle exec guard
```

# Test

```bash
bundle exec rake
```
