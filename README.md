# pysdr
An R wrapper for pysd, using the CRAN reticulate package

The goal of this package is to allow R users run system dynamics models using the [pysd](
https://pysd.readthedocs.io/en/master/), developed by James Houghton. The pysd
project "is a simple library for running System Dynamics models in python, with the purpose of 
improving integration of Big Data and Machine Learning into the SD workflow."

Given R's facility for also providing big data and machine learning support, this package opens up the functionality of pysd for R users, and provides an interface to the basic set of methods provided by pysd, including the functions:


* pysd.read_vensim()
* model.run()

The following example shows how pysd2r can be used to run a simulation model (Population.mdl which is a one-stock model of population growth)

```R
library(pysd2r)  # load pysd2r
library(ggplot2) # load ggplot2
library(tibble)  # load tibble
```

First, a connection is made to pysd

```R
py <- pysd_connect()
```

Next, the vensim file is opened.

```R
target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
py <- read_vensim(py, target)
```

The returning object (ipysd, and S3 class) can be inspected. This is a list with two elements. The first is the reference to pysd, the second is a referece to the translated python model

```R
str(py)
```

With this reference, the simulation can be run by calling the run_model() function.

```R
results <- run_model(py)
```

The results from the tibble can be shown.


```R
results
```

These results can also be processed using ggplot2.

```R
ggplot(data=results)+
  geom_point(aes(x=TIME,y=Population),colour="blue")
```

