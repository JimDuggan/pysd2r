# pysdr
An R wrapper for pysd, using the CRAN reticulate package.

The goal of this package is to allow R users run system dynamics models using the [pysd](
https://pysd.readthedocs.io/en/master/), developed by James Houghton. The pysd
project "is a simple library for running System Dynamics models in python, with the purpose of 
improving integration of Big Data and Machine Learning into the SD workflow."

The pysd system must be installed before installing this package: [see pysd installation instructions](
https://pysd.readthedocs.io/en/master/installation.html)

pysd2r has been tested with python3, and the following command was used to install pysd from source.

[Source link:](https://github.com/JamesPHoughton/pysd)

**python3 setup.py install**

Given R's facility for also providing big data and machine learning support, this package opens up the functionality of pysd for R users, and provides an interface to the basic set of methods provided by pysd, including the functions:


* pysd.read_vensim()
* model.run()

The API provide by pysd2r includes the following functions (for list of parameters type ?*function_name* in R) which call the mapping functions in pysd.

* **get_python_info()** - Returns the python version currently used by reticulate
* **pysd_connect()** - Creates an object to facilitate interaction with pysd
* **read_vensim()** - Loads a Vensim simulation file (mdl)
* **read_xmile()** - Loads a XMILE simulation file (.xmile)
* **run_model()**  - Runs a simulation model
* **set_components()** - Changes a model parameter
* **get_timestep()** - Gets the time step (DT) from the model
* **get_initial_time()** - Gets the initial time from the model
* **get_final_time()** - Gets the final time from the model
* **set_time_values()** - Sets the initial time, final time, and timestep
* **print()** - Implementation of generic print function of ipysd S3 object
* **get_doc()** - Gets the model variables and returns as a tibble
* **reload_model()** - Reloads the original mdl file


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

The returning object py is of type **ipysd** -  an S3 class.

With this reference, the simulation can be run by calling the run_model() function.

```R
results <- run_model(py)
```

These results can also be processed using ggplot2.

```R
ggplot(data=results)+
  geom_point(aes(x=TIME,y=Population),colour="blue")
```

