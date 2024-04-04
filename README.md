# Clonezilla Customizer

[Docker](https://www.docker.com/) image and dockerized github action to create custom [Clonezilla](https://clonezilla.org/) images.


## Introduction

Clonezilla is a partition and disk imaging/cloning program similar to True Image® or Norton Ghost®. \
... \
Clonezilla saves and restores only used blocks in the hard disk. This increases the clone efficiency. \
**clonezilla.org**

Clonezilla is provided as `*.iso` file (called `clonezilla image`) to boot from.

**Clonezilla Customizer** uses [this approach](https://clonezilla.org/advanced/customized-clonezilla-live.php) (but dockerized) to create custom clonezilla images (e. g. for simplification or to add features).

## Docker image
With the Docker image, you can create custom clonezilla images using docker.

### Prerequisites
Docker installed and ready.

### Usage
* Create a `workdirectory` (e. g. `~/workdir`) \
  See [workdirectory](#workdirectory) for further details.
* Open an terminal and execute this:
  ```shell
  # cd to your workdirectory (assuming ~/workdir)
  cd ~/workdir

  # create the custom image (assuming running in bash)
  docker run -it -v $(pwd):/opt/work clonezilla_customizer
  ```

Now you will find your new custom image(s) in the `dist` sub directory in your `workdirectory`
(e. g. `~/workdir/dist/`).


## Dockerized github action
With the dockerized github action, you can create custom clonezilla images using github actions.

### Prerequisites
You will need a github `repository` with code to create the image upon.

### Usage
* Create a `workdirectory` in your `repository` (e. g. `release/workdir`) \
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

Now you will find your new custom image(s) in the sub directory `dist` in your `workdirectory`
(e. g. `release/workdir/dist/`), so you can do things with it in further steps/actions.

## Workdirectory

The `workdirectory` contains the base images, the `custom-ocs` file and optionally additional files (e. g. binary files to be added to the custom image(s)). \
**Clonezilla Customizer** will create the custom images inside the `dist` sub directory.

### Contents
* `base` directory &minus; Place the clonezilla base image(s) (`*.iso`) here, to create the custom image(s) upon. \
  For each base image placed here, **Clonezilla Customizer** creates a custom image upon.
* `custom-ocs` file &minus; See [customized-clonezilla-live documentation](https://clonezilla.org/advanced/customized-clonezilla-live.php)
* `dist` directory &minus; **Clonezilla Customizer** creates the custom images to this directory.
  The directory will be created automatically, if it doesn't exist.
* Optional: `extra` directory &minus; Each file and directory in this directory will be available in the custom image(s),
  under `/run/live/medium/live/extra`

### Example
`Workdirectory` contents before **Clonezilla Customizer** execution:
* `base`:
  * `clonezilla-live-3.1.2-9-amd64.iso`
* `custom-ocs` \
  (Boot into clonezilla and look in `/usr/share/drbl/samples/` for examples)
* `extra`
  * `lynx` \
    (text-based browser)

Workdirectory contents after **Clonezilla Customizer** execution:
* `base`:
  * `clonezilla-live-3.1.2-9-amd64.iso`
* `custom-ocs` \
  (Boot into clonezilla and look in `/usr/share/drbl/samples/` for examples)
* `dist`
  *  `clonezilla-live-3.1.2-9-amd64__customized.iso`
* `extra`
  * `lynx` \
    (binary file of the text-based browser `lynx`)

The custom image `clonezilla-live-3.1.2-9-amd64__customized.iso` will run `custom-ocs` instead of `ocs-live-general`, will use en_US.UTF-8 and default (US) keyboard layout. \
The `lynx` binary file will be available in the custom image: `/run/live/medium/live/extra/lynx`.

## Limitations

**Clonezilla Customizer** is a little opinionated.

* Only `*.iso` files will be used as base and only `*.iso` files will be created. \
  This shouldn't be that bad, since most Bootable-Flash-Drive-Creation tools also use `*.iso` files nowadays.
* Only the architecture of the base image will be used
  (e. g. giving an amd64 base image will not produce an i686 image)
* Custom images will always use en_US.UTF-8 and default (US) keyboard layout.
* Only tested on amd64 architectures
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
