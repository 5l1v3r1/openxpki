# Docker image for OpenXPKI test suite

This is an easy way to run the OpenXPKI test suite on any Git branch.

Image specifications:

* Ubuntu 14.04
* Standard system Perl v5.18.2
* MySQL Server 5.5

## Usage

The easiest way to use this image is by calling `tools/docker-test.pl`.

## (Re-)Build image

The Docker image has to be built once (after changes to its configuration):

    # assuming you are in the project's root directory:
    # (register image as "oxi-test" for easier access)
    docker build -t oxi-test tools/docker-test

**Attention**: as the Docker image comes preinstalled with a lot of CPAN modules
it will not reliably detect missing dependency specifications in Makefile.PL!

### Update preinstalled Perl modules

The list of preinstalled Perl modules for the Docker image is managed in `cpanfile`. To update it run this from the project's root directory:

    ./tools/scripts/makefile2cpanfile.pl > tools/docker-test/cpanfile

After that, rebuild the Docker image as shown above.

## Run tests on "develop" branch

Without any arguments the Docker container will fetch the "develop" branch from
the official OpenXPKI Github repository and run the test suite:

    # https://github.com/openxpki/openxpki.git, branch "develop"
    docker run -t -i --rm oxi-test

### Other Git branch

To choose another branch than "develop", give it as first argument:

    # https://github.com/openxpki/openxpki.git, branch "newfeature"
    docker run -t -i --rm oxi-test newfeature

### Other Github repository

To choose another repository, give it as second argument:

    # https://github.com/maxhq/openxpki.git, branch "fixes"
    docker run -t -i --rm oxi-test fixes maxhq/openxpki

### Use local repository

To run the tests on a local HEAD commit (not your working directory!) you have
to mount your host repository root into the Docker directory `/repo` via `-v`:

    # /home/tux/oxi-dev, branch "develop"
    docker run -t -i --rm -v /home/tux/oxi-dev:/repo oxi-test

    # /home/tux/oxi-dev, branch "fixes"
    docker run -t -i --rm -v /home/tux/oxi-dev:/repo oxi-test fixes
