This repository contains the [jpegview chocolatey package](https://chocolatey.org/packages/jpegview) source for the [JPEGView](https://sourceforge.net/projects/jpegview/) application.

Run `choco pack` to create the chocolatey nuget package.

Run `choco install -y -source $pwd -f jpegview -version 1.0.35.1` to install the package.

NB replace the `-version` argument with the current package version.

Run the following to publish the package to chocolatey.org:

```ps
choco apikey -k API-KEY -source https://chocolatey.org/
choco push -source https://chocolatey.org/
```
