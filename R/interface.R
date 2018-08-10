# Sys.setenv(RETICULATE_PYTHON="/usr/local/bin/python3")
library(reticulate)
library(tibble)

pysd <- NULL

check_python_version <- function(){
  message("Checking for the python version...")
  psys <- import("sys")
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
  check_python_version()
}


pysd_connect <- function (){
  structure(list(py_link=pysd,
                 model=c()),class="ipysd")
}

#------------------------------------------------------------------------------------
read_vensim <- function(o, p1){
  UseMethod("read_vensim")
}

read_vensim.ipysd <- function(i, file){
  m <- i$py_link$read_vensim(file)
  i$model <- m
  i
}

#------------------------------------------------------------------------------------
run_model <- function(o){
  UseMethod("run_model")
}

run_model.ipysd <- function(i){
  o <- as_data_frame(i$model$run())
}


#------------------------------------------------------------------------------------
set_components <- function(i,vals){
  UseMethod("set_components")
}

set_components.ipysd <- function(i,vals){
  conv <- reticulate::r_to_py(vals)
  i$model$set_components(params = conv)
}

#------------------------------------------------------------------------------------
get_timestep <- function(i){
  UseMethod("get_timestep")
}

get_timestep.ipysd <- function(i){
  py$model$components$time_step()
}

#------------------------------------------------------------------------------------
get_initial_time <- function(i){
  UseMethod("get_initial_time")
}

get_initial_time.ipysd <- function(i){
  py$model$components$initial_time()
}
#------------------------------------------------------------------------------------
get_final_time <- function(i){
  UseMethod("get_final_time")
}

get_final_time.ipysd <- function(i){
  py$model$components$final_time()
}
#------------------------------------------------------------------------------------
get_saveper <- function(i){
  UseMethod("get_saveper")
}

get_saveper.ipysd <- function(i){
  py$model$components$saveper()
}


