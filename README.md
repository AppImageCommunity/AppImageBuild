# AppImageBuild -- resources for building AppImageKit

## Docker images

The Docker images defined by the Dockerfiles in this repository contain all the tools required for building [AppImageKit](https://github.com/AppImage/AppImageKit).

The goal is to shorten the AppImageKit build times by moving the dependency installation to a single central place. Instead of using less trustworthy dependency sources, such dependencies are built and set up from source.

The images will be built and published in a Docker library, and pulled during the build process by Travis CI.
