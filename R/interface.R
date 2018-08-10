# Sys.setenv(RETICULATE_PYTHON="/usr/local/bin/python3")
library(reticulate)
library(tibble)

pysd <- NULL

check_python_version <- function(){
  message("Checking for the python version...")
  psys <- reticulate::import("sys")
  v <- strtoi(substr(psys$version,1,1))
  message(paste("Version",psys$version,"detected..."))
  if (v < 3){
    message("Load error: pysd2r has only been tested with python3...")
    message("Check to see if RETICULATE_PYTHON points to python3")
    message("Use the function reticulate::py_config()")
    stop("Exiting pysd2r.")
  }
}

.onLoad <- function(libname, pkgname) {
  tryCatch(
    {
      message("Checking for the pysd module...")
      pysd <<- reticulate::import("pysd", delay_load = TRUE)
      message("Successfully loaded pysd module...")
    },
    error=function(cond) {
      message("Cannot find pysd, ensure it is installed...")
      message("Here's the original error message:")
      message(cond)
      return(NA)
    },
    warning=function(cond) {
      message("Here's the original warning message:")
      message(cond)
      # Choose a return value in case of warning
      return(NULL)
    },
    finally={
    }
  )
  #check_python_version()
}

#' Creates an object to facilitate interaction with pysd
#'
#' \code{pysd_connect} returns a ipysd object to the calling program.
#' This object will contain a link variable to pysd and will subsequently
#' store a reference to the simulation model in pysd.
#'
#' \href{https://pysd.readthedocs.io/en/master/}{Link to pysd}
#'
#' The result is used as a parameter for read_vensim() & read_xmile() functions
#'
#' @return An S3 object of class ipysd
#' @export
pysd_connect <- function (){
  if(is.null(pysd)){
    stop("pysd2r error: no connection to python via rectiulate...")
  }
  structure(list(py_link=pysd,
                 model=c()),class="ipysd")
}

#' Loads a Vensim simulation file (mdl)
#'
#' \code{read_vensim()} calls \code{pysd.read_vensim()} and stores the object for
#' further use. This is a key object, as it relates to a model and it can
#' support a number of functions (e.g. model run, parameter changes)
#'
#' The result is used as a parameter for simulation calls.
#'
#' As it's a generic function, this call is dispatched to read_vensim.isdpy
#'
#' @param o is the ipysd S3 object
#' @param file is the filename and path for the Vensim mdl file that needs to be simulated
#' @return An S3 object of class ipysd that will contain a reference to the model
#' @export
read_vensim <- function(o, file){
  UseMethod("read_vensim")
}

#' @export
read_vensim.ipysd <- function(i, file){
  tryCatch(
    {m <- i$py_link$read_vensim(file)
     i$model <- m
     i
    },
    error=function(cond) {
      message("pysd2r error: cannot find file, check file path...")
      message("Here's the original error message:")
      message(cond)
      return(NA)},
    finally={
    })
}


#' Loads a XMILE simulation file (.xmile)
#'
#' \code{read_xmile()} calls \code{pysd.read_xmile()} and stores the object for
#' further use. This is a key object, as it relates to a model and it can
#' support a number of functions (e.g. model run, parameter changes)
#'
#' The result is used as a parameter for simulation calls.
#'
#' As it's a generic function, this call is dispatched to read_xmile.isdpy
#'
#' @param o is the ipysd S3 object
#' @param file is the filename and path for the Vensim mdl file that needs to be simulated
#' @return An S3 object of class ipysd that will contain a reference to the model
#' @export
read_xmile <- function(o, file){
  UseMethod("read_xmile")
}

#' @export
read_xmile.ipysd <- function(i, file){
  tryCatch(
    {m <- i$py_link$read_xmile(file)
    i$model <- m
    i
    },
    error=function(cond) {
      message("pysd2r error: cannot find file, check file path...")
      message("Here's the original error message:")
      message(cond)
      return(NA)},
    finally={
    })
}

#' Runs a simulation model
#'
#' \code{run_model()} calls \code{run} in pysd and returns all
#' the simulation output in tidy data format (tibble)
#'
#' As it's a generic function, this call is dispatched to run_model.isdpy
#'
#' @param o is the ipysd S3 object
#' @return tibble containing the simulation results
#' @export
run_model <- function(o){
  UseMethod("run_model")
}

#' @export
run_model.ipysd <- function(i){
  o <- tibble::as_data_frame(i$model$run())
}

#' Changes a model parameter
#'
#' \code{set_components()} calls \code{.set_components()} and changes
#' a resulting parameter in the model
#'
#'
#' As it's a generic function, this call is dispatched to set_component.isdpy
#'
#' @param o is the ipysd S3 object
#' @param vals contains a list with the parameter and value to be changed
#' @export
set_components <- function(o,vals){
  UseMethod("set_components")
}

#' @export
set_components.ipysd <- function(i,vals){
  conv <- reticulate::r_to_py(vals)
  i$model$set_components(params = conv)
}

#' Gets the time step (DT) from the model
#'
#' \code{get_timestep} uses pysd to fetch the time step from the model
#'
#' As it's a generic function, this call is dispatched to set_component.isdpy
#'
#' @param o is the ipysd S3 object
#' @return The simulation time step
#' @export
get_timestep <- function(o){
  UseMethod("get_timestep")
}

#' @export
get_timestep.ipysd <- function(i){
  i$model$components$time_step()
}

#' Gets the initial time from the model
#'
#' \code{get_initial_time} uses pysd to fetch the time step from the model
#'
#' As it's a generic function, this call is dispatched to set_component.isdpy
#'
#' @param o is the ipysd S3 object
#' @return The initial time
#' @export
get_initial_time <- function(o){
  UseMethod("get_initial_time")
}

#' @export
get_initial_time.ipysd <- function(i){
  i$model$components$initial_time()
}
#' Gets the initial time from the model
#'
#' \code{get_timestep} uses pysd to fetch the time step from the model
#'
#' As it's a generic function, this call is dispatched to set_component.isdpy
#'
#' @param o is the ipysd S3 object
#' @return The finaltime
#' @export
get_final_time <- function(o){
  UseMethod("get_final_time")
}

#' @export
get_final_time.ipysd <- function(i){
  i$model$components$final_time()
}
