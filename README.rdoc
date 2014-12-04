**setup token files**

```
$ cp token.yml.sample token.yml
```

- write token file some token

```
$ vim token.yml
```

**boot observe daemon process**

```
$ bundle exec rails runner Stream.run
```

**somehow gitter api client wrong**

```
$ git clone git@github.com:kristenmills/ruby-gitter.git
$ cd ruby-gitter
$ rake install
```


**Activate Solr**

```
$ rails generate sunspot_rails:install
$ bundle exec rake sunspot:solr:run
```
