# dockerized libbitcoin

## bitcoin explorer

A linux image can be generated with the script below. Currently, this is only tested against the `version3` branch with or without the `v3.8.0` tag.

### linux

The following outlines usage of the `bx-linux` artifacts.

#### Image construction

The image construction can then continue via an other invocatio with the following parameters:

```
./bx-linux.sh --build-dir=<image build dir> --source=<gsl xml source>
```

#### Container usage

The generated image can be used to execute the `bx` tool via the following:

```
docker run --interactive --tty --rm --user $(id -u):$(id -g) libbitcoin/bitcoin-explorer:<version>
```

## bitcoin server

A linux image can be generated with the script below. Currently, this is only tested against the `version3` branch with or without the `v3.8.0` tag.

### linux

The following outlines usage of the `bs-linux` artifacts.
It is of note that the generated image includes a `startup.sh` script which conditionally initializes the blockchain database if not found.

#### Initialization

The following populates a provided image build directory:

```
./bs-linux.sh --build-dir=<image build dir> --source=<gsl xml source> --init-only
```

The reader then needs to edit the generated `bs-linux.env` to provide storage paths for volume mounting.
Additionally, the `STORAGE_BITCOIN_CONF` path should contain a `bs.cfg` containing a `directory` field for `[database]` which has some depth from the volume mount point, due to `bs` implementation attempts to create the blockchain containing directory.

#### Image construction

The image construction can then continue via an other invocatio with the following parameters:

```
./bs-linux.sh --build-dir=<image build dir> --source=<gsl xml source> --build-only
```

#### Container management

The file `bs-linux.yml` is provided in the image build directory in order to allow `docker compose` to control container construction and destruction.
The reader is free to translate this file and the `bs-linux.env` into `docker` commands derived from the declative `yaml`.
The timeout parameter should be noted: `bs` has been known to take an extended period of time to write memory to disk and `SIGKILL` will likely corrupt the database.

##### Instantiating container
```
docker compose --env-file bs-linux.env --file bs-linux.yml up -t 3600 -d
```

##### Terminating container
```
docker compose --env-file bs-linux.env --file bs-linux.yml down -t 3600 -v
```
