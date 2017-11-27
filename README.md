# README

Build and run:

```bash
$ docker build -t braintree_broke .
$ docker run -p 3333:80 braintree_broke
```

Trigger error:

```bash
$ curl localhost:3333
```
