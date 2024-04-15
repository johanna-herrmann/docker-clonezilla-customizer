# Clonezilla Customizer

[Docker](https://www.docker.com/) image and dockerized github action to create a custom [Clonezilla](https://clonezilla.org/) image,
based on a given clonezilla image.


## Introduction

Clonezilla is a partition and disk imaging/cloning program similar to True Image® or Norton Ghost®. \
... \
Clonezilla saves and restores only used blocks in the hard disk. This increases the clone efficiency. \
**clonezilla.org**

Clonezilla is provided as `*.iso` file (called `clonezilla image`) to boot from.

**Clonezilla Customizer** uses [this approach](https://clonezilla.org/advanced/customized-clonezilla-live.php) (but dockerized)
to create a custom clonezilla image (e. g. for simplification or to add features), based on a given clonezilla image.

## Docker image
With the Docker image, you can create the custom clonezilla image using docker.

### Prerequisites
Docker installed and ready.

### Usage
* Create a `workdirectory` (e. g. `~/workdir`),
  containing the base image and a `custom-ocs` file. \
  See [workdirectory](#workdirectory) for further details.
* Open an terminal and execute this:
  ```shell
  # cd to your workdirectory (assuming ~/workdir)
  cd ~/workdir

  # create the custom image (assuming running in bash)
  docker run -it -v $(pwd):/opt/work --cap-add SYS_ADMIN clonezilla_customizer
  ```

Now you will find your new custom image in your `workdirectory`, named `clonezilla_customized.iso`
(e. g. `~/workdir/clonezilla_customized.iso`).


## Dockerized github action
With the dockerized github action, you can create the custom clonezilla image using github actions.

### Prerequisites
You will need a github `repository` with code to create the image upon.

### Usage
* Create a `workdirectory` in your `repository` (e. g. `release/workdir`),
  containing the base image and a `custom-ocs` file. \
  See [workdirectory](#workdirectory) for further details.
* Create a workflow in your `repository` (e. g. `.github/workflow.yml`)
  and specify your `workdirectory` (relative to your `repository`).
  * Example
    ```yaml
    on: [push]

    jobs:
      create_custom_image:
        runs-on: ubuntu-latest
        name: This jobs creates the custom image
        steps:
          - name: custom image creation action step
            id: creator
            uses: johanna-herrmann/docker-clonezilla-customizer@v1
            with:
              workdirectory: 'release/workdir'

      use_image:
        runs-on: ubuntu-latest
        name: Job to do something with the custom image
        steps:
          ## Do what ever you want with your new custom image
    ```

Now you will find your new custom image in your `workdirectory`, named `clonezilla_customized.iso`
(e. g. `release/workdir/clonezilla_customized.iso`), so you can do things with it in further steps/actions.

## Workdirectory

The `workdirectory` contains the base image, the `custom-ocs` file and optionally additional files (e. g. binary files to be added to the custom image).

### Contents
* `clonezilla.iso` file &minus; The base image to create the custom image upon. Must be called `clonezilla.iso`.
* `custom-ocs` file &minus; See [customized-clonezilla-live documentation](https://clonezilla.org/advanced/customized-clonezilla-live.php)
* Optional: `extra` directory &minus; Each file and directory in this directory will be available in the custom image,
  under `/run/live/medium/live/extra`

### Example
`Workdirectory` contents before **Clonezilla Customizer** execution:
* `clonezilla.iso`
* `custom-ocs` \
  (Boot into clonezilla and look in `/usr/share/drbl/samples/` for examples)
* `extra`
  * `lynx` \
    (text-based browser)

Workdirectory contents after **Clonezilla Customizer** execution:
* `clonezilla.iso`
* `custom-ocs`
* `clonezilla_customized.iso`
* `extra`
  * `lynx`

The custom image `clonezilla_customized.iso` will run `custom-ocs` instead of `ocs-live-general`, will use en_US.UTF-8 and default (US) keyboard layout. \
The `lynx` binary file will be available in the custom image, under: `/run/live/medium/live/extra/lynx`.

## Limitations

**Clonezilla Customizer** is a little opinionated.

* Only `*.iso` files will be used as base and only `*.iso` files will be created. \
  This shouldn't be that bad, since most Bootable-Flash-Drive-Creation tools also use `*.iso` files nowadays.
* Only the architecture of the base image will be used
  (e. g. giving an amd64 base image will not produce an i686 image)
* Custom images will always use en_US.UTF-8 and default (US) keyboard layout.
* Only tested on amd64 architectures
* Specific naming of base and custom image
* No further configurations or options

## License and credits

### Clonezilla
* Licensed under a [GNU General Public License v2.0](./LICENSE_clonezilla)
* [Source](https://github.com/stevenshiau/clonezilla)
* Maintainer: [Steven Shiau](https://github.com/stevenshiau/)

### Clonezilla Customizer
* Licensed under a [GNU General Public License v2.0](./LICENSE)
* [Source](https://github.com/johanna-herrmann/clonezilla_customizer)
* Maintainer: [Johanna Herrmann](https://github.com/johanna-herrmann/)
