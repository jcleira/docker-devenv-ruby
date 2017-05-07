# Dockerized ruby development environment
[!Docker ruby environment](http://i.imgur.com/w3WQWzQ.png)

This repository contains a dockerized development environment for ruby (2.1.2), It's customized using my dotfiles and crafted with love.

Usage:

```bash
docker run -t -i -v /home/<user>/.ssh:/home/dev/.ssh -v /home/<user>/.ssh:/home/dev/.ssh -v /home/<user>/Code:/home/dev/Code --net=host jcorral/docker-devenv-ruby
```
