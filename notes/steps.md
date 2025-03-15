# Steps to reproduce the same state

## Setting up the environment for new vcpkg

```sh
export VCPKG_ROOT=<root_path_to_clean_vcpkg_clone>
export PATH=$VCPKG_ROOT:$PATH
```

## Creating basic files

Based on the documentation [Tutorial: Publish packages to a private vcpkg registry using Git](https://learn.microsoft.com/en-us/vcpkg/produce/publish-to-a-git-registry),
create the `ports`, `versions` folders and the `baseline.json` file.

## Copying custom ports from MegaSDK

Copy the ports from the `<sdk>/cmake/vcpkg_overlay_ports` folder to the `ports` folder.

## Fixing formatting in the pdfium Port

```sh
vcpkg format-manifest ./ports/pdfium/vcpkg.json
```

## Creating a commit for the ports

```sh
git init
git add ports
git commit -m "Copied ports from MegaSDK v8.6.0"
```

Now the `vcpkg x-add-version` command can use the port hashes to register the port versions.

## Registering ports in the registry

```sh
vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version ffmpeg --verbose --skip-version-format-check
vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version jxrlib --verbose --skip-version-format-check
vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version libraw --verbose --skip-version-format-check
vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version pdfium --verbose --skip-version-format-check
vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version readline-unix --verbose --skip-version-format-check
git add versions
git commit -m "Registered ports from MegaSDK"
```

Skipping the port version check is necessary because this registry does not have, for example, 10 versions of the `ffmpeg` port.
