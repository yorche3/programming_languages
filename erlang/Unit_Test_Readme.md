
# Unit Test projects with Rebar3 and Erlang with Eunit
How were built unit test projects.

## Requisites
- Install
  - [Erlang](https://www.erlang.org/)
  - Rebar3

## Structure
```text
demo
|--- src
|    |--- demo.app.src
|--- test
|--- rebar.config
```

## Configure
- Initialize running:
```bash
rebar3 new app demo
```

## Build project

## Modify project
```
## Compile and run tests
### Compile
```bash
rebar3 compile
```
**Nota** no es necesario
```bash
rebar3 eunit
```