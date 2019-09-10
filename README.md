# CF Summit EU 2019 - Sample Release

This repository contains the BOSH release for the talk "Automated Side-by-Side development of applications for BOSH and Kubernetes" at the CF Summit Europe 2019.

1. Architecture
2. Installation
3. Usage

## Architecture

The BOSH release contains a **packaging** script to compile and a **job** to start the sample application which can be found here: https://github.com/anynines/cfeu19-sample-app

The sample application is included in this repository using **git submodules** which allows to link the additional repository inside the **src** folder of the BOSH release.

## Installation

Before creating and uploading the BOSH release to the director, the git submodule needs to be initialized and updated using

```sh
git submodule init
git submodule update
```
