# checkpass

## Usage

```console
> checkpass password
Password found 3861493 times!
```

```console
> checkpass --help
OVERVIEW: Checks a password against the Pwned Passwords API.

USAGE: checkpass [<password>] [--silent]

ARGUMENTS:
  <password>              The password to check.
        If no input is provided, the tool reads from stdin.

OPTIONS:
  --silent                Silent mode.
  -h, --help              Show help information.
```

## Installation

```console
brew tap nixberg/tap
brew install checkpass
```
