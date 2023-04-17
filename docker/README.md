# Packer executor docker

A hardened docker image to execute packer commands on demand inside a
CodeBuilder build.

## Building

If you need to build this repository manually use this commands (you need to
have a set of required permissions on system account to be successful). be sure
to tag and push all changes accordly before continue:

```bash
export VERSION=$(git describe --abbrev=0)
```

```bash
eval $(aws ecr get-login --no-include-email)
```

```bash
docker build -t packer-executor:${VERSION} -t 590191714839.dkr.ecr.us-east-1.amazonaws.com/packer-executor:${VERSION} .
```

```bash
docker push 590191714839.dkr.ecr.us-east-1.amazonaws.com/packer-executor:${VERSION}
```
