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

# Creating and populating the megasdk Port

After making all the changes in MegaSDK to allow it to compile properly in the `vcpkg` environment, separate commits were created with names briefly describing the purpose of each specific change. These commits were then converted into 11 patches presented in the `./ports/megasdk` folder.

*Especially* worth mentioning is the change in the `./cmake/modules/Config.cmake.in` file, based on which the `*config.cmake` file is created during project installation. It uses a macro applied to search for archaically structured dependencies. This is discussed in the response to the question [check_required_components logics](https://discourse.cmake.org/t/check-required-components-logics/10567). There is an important reference to this macro in the CMake book.

The `vcpkg.json` file contains many enabled `default-features` with conditional activation depending on the platform. For this, the `platform` tag is used for each `default-features` element. The enabled `default-features` options correspond to those described in the `./cmake/modules/sdklib_options.cmake` file from MegaSDK.
For more details about the list of platforms, you can read in the following section [vcpkg.json Reference. Platform Expression](https://learn.microsoft.com/en-us/vcpkg/reference/vcpkg-json#platform-expression).

After this, we create a commit so that `vcpkg x-add-version` can find this port.

```sh
git add ports/megasdk
git commit -m "Added megasdk port"
```

# Registering the Port Version

```sh
vcpkg --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version megasdk --verbose
git add versions/
git commit -m "Register megasdk port (it's version)"
```

**Everything is ready for use**
