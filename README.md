## QA3D 0.0.1

## Installation
```R
install.packages("devtoolk")
library(devtools)
install_github("jjlynch2/QA3D", ref="v0.0.1")
library(QA3D)
QA3D()
```

## Desktop Icon
Once you run QA3D(), clicking the Desktop Shortcut button on the dashboard will allow you to run QA3D without launching R manually.

## R Dependencies
The following will be installed automatically:
* Morpho
* DT
* shiny
* htmltools
* zip
* rgl
* ClusterR
* JuliaCall
* rmarkdown
* knitr

## Julia Dependencies
The following will be installed automatically:
* Distributed
* SharedArrays

## Other Windows Dependencies
The following needs to be installed manually:
* Requires MiKTeX for Windows https://miktex.org/download
* Requires Pandoc for Windows https://pandoc.org/installing.html
* Julia must be in your PATH to run.