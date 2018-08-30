# MAy need this path set Sys.setenv(RETICULATE_PYTHON="/usr/local/bin/python3")
library(reticulate)
library(tibble)

#-------------------------------------------------------------------------------------
check_python_version <- function(){
  #packageStartupMessage("Checking for the python version...")
  psys <- reticulate::import("sys")
  v <- strtoi(substr(psys$version,1,1))
  #packageStartupMessage(paste("Version",psys$version,"detected..."))
  if (v < 3){
    packageStartupMessage("Load error: pysd2r has only been tested with python3...")
    packageStartupMessage("Check to see that RETICULATE_PYTHON points to python3")
    packageStartupMessage("Use the function pysd2r::get_python_info() to check current configuration")
    stop("Exiting pysd2r.")
  }
}

#-------------------------------------------------------------------------------------
check_pysd_present <- function(){
  tryCatch(
    {
      #packageStartupMessage("Checking for the pysd module...")
      pysd <- reticulate::import("pysd")
      #packageStartupMessage("Successfully loaded pysd module...")
      #print("Successfully loaded pysd module...")
      pysd
    },
    error=function(cond) {
      packageStartupMessage("Cannot find pysd, ensure it is installed...")
      packageStartupMessage("Here's the original error message:")
      packageStartupMessage(cond)
      return(NA)
    },
    warning=function(cond) {
      packageStartupMessage("Here's the original warning message:")
      packageStartupMessage(cond)
      # Choose a return value in case of warning
      return(NULL)
    },
    finally={
    }
  )
}

#-------------------------------------------------------------------------------------
.onLoad <- function(libname, pkgname) {
  #check_python_version()
  #check_pysd_present()

}

#-------------------------------------------------------------------------------------
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Welcome to package pysd2r.")
}

#-------------------------------------------------------------------------------------
#' Gets the current python configuration for reticulate
#'
#' \code{get_python_info} returns information on what version of python
#' is being used with reticulate
#'
#'
#' @return python information
#' @export
#' @examples
#' \dontrun{
#' get_python_info()
#' }
get_python_info <- function(){
  reticulate::py_config()
}

#-------------------------------------------------------------------------------------
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
#' @examples
#' \dontrun{
#' py pysd_connect()
#' }
pysd_connect <- function (){
  check_python_version()
  pysd <- check_pysd_present()
  if(is.null(pysd)){
    stop("pysd2r error: no connection to python via rectiulate...")
  }
  structure(list(py_link=pysd,
                 connected=T,
                 connect_time=Sys.time(),
                 loaded_model=F,
                 reloaded_model=F,
                 model=c()),class="ipysd")
}

#-------------------------------------------------------------------------------------
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
#' @examples
#'\dontrun{
#' target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
#' py <- pysd_connect()
#' read_vensim(py, target)
#' }
read_vensim <- function(o, file){
  if(o$connected == F || is.null(o))
    stop("Error, no connection made. Need to call pysd_connect() befoe read_vensim()")
  UseMethod("read_vensim")
}

#' @export
read_vensim.ipysd <- function(o, file){
  tryCatch(
    {m <- o$py_link$read_vensim(file)
     o$loaded_model <- TRUE
     o$model <- m
     o
    },
    error=function(cond) {
      packageStartupMessage("pysd2r error: cannot find file, check file path...")
      packageStartupMessage("Here's the original error message:")
      packageStartupMessage(cond)
      return(o)},
    finally={
    })
}

#-------------------------------------------------------------------------------------
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
#' @examples
#'\dontrun{
#' target <- system.file("models/xmile", "Population.xmile", package = "pysd2r")
#' py <- pysd_connect()
#' read_xmile(py, target)
#'}
read_xmile <- function(o, file){
  if(o$connected == F || is.null(o))
    stop("Error, no connection made. Need to call pysd_connect() befoe read_xmile()")
  UseMethod("read_xmile")
}

#' @export
read_xmile.ipysd <- function(o, file){
  tryCatch(
    {m <- o$py_link$read_xmile(file)
    o$loaded_model <- TRUE
    o$model <- m
    o
    },
    error=function(cond) {
      packageStartupMessage("pysd2r error: cannot find file, check file path...")
      packageStartupMessage("Here's the original error message:")
      packageStartupMessage(cond)
      return(o)},
    finally={
    })
}

#-------------------------------------------------------------------------------------
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
#' @examples
#' \dontrun{
#' target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
#' py <- pysd_connect()
#' py <- read_vensim(py, target)
#' results <- run_model(py)
#' }
run_model <- function(o){
  if(o$connected == F || is.null(o))
    stop("Error, no connection made. Need to call pysd_connect() befoe run_model()")
  if(o$loaded_model == F)
    stop("Error, no model loaded...")
  UseMethod("run_model")
}

#' @export
run_model.ipysd <- function(o){
  out <- tibble::as_data_frame(o$model$run())
}

#-------------------------------------------------------------------------------------
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
#' @examples
#'\dontrun{
#' target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
#' py <- pysd_connect()
#' py <- read_vensim(py, target)
#' results <- run_model(py)
#' l <- list("Growth Fraction"=0.02)
#' set_components(py,l)
#' out2 <- run_model(py)
#'}
set_components <- function(o,vals){
  if(o$connected == F || is.null(o))
    stop("Error, no connection made. Need to call pysd_connect() before set_components()")
  if(o$loaded_model == F)
    stop("Error, no model loaded...")
  UseMethod("set_components")
}

#' @export
set_components.ipysd <- function(o,vals){
  conv <- reticulate::r_to_py(vals)
  o$model$set_components(params = conv)
}

#-------------------------------------------------------------------------------------
#' Gets the time step (DT) from the model
#'
#' \code{get_timestep} uses pysd to fetch the time step from the model
#'
#' As it's a generic function, this call is dispatched to set_component.isdpy
#'
#' @param o is the ipysd S3 object
#' @return The simulation time step
#' @export
#' @examples
#'\dontrun{
#' target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
#' py <- pysd_connect()
#' py <- read_vensim(py, target)
#' time_step  <- get_timestep(py)
#' }
get_timestep <- function(o){
  if(o$connected == F || is.null(o))
    stop("Error, no connection made. Need to call pysd_connect() befoe get_timestep()")
  if(o$loaded_model == F)
    stop("Error, no model loaded...")
  UseMethod("get_timestep")
}

#' @export
get_timestep.ipysd <- function(o){
  o$model$components$time_step()
}

#-------------------------------------------------------------------------------------
#' Gets the initial time from the model
#'
#' \code{get_initial_time} uses pysd to fetch the time step from the model
#'
#' As it's a generic function, this call is dispatched to set_component.isdpy
#'
#' @param o is the ipysd S3 object
#' @return The initial time
#' @export
#' @examples
#' \dontrun{
#' target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
#' py <- pysd_connect()
#' py <- read_vensim(py, target)
#' initial_time <- get_initial_time(py)
#' }
get_initial_time <- function(o){
  UseMethod("get_initial_time")
}

#' @export
get_initial_time.ipysd <- function(o){
  o$model$components$initial_time()
}

#-------------------------------------------------------------------------------------
#' Gets the final time from the model
#'
#' \code{get_timestep} uses pysd to fetch the time step from the model
#'
#' As it's a generic function, this call is dispatched to set_component.isdpy
#'
#' @param o is the ipysd S3 object
#' @return The finaltime
#' @export
#' @examples
#'\dontrun{
#' target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
#' py <- pysd_connect()
#' py <- read_vensim(py, target)
#' final_time <- get_final_time(py)
#'}
get_final_time <- function(o){
  UseMethod("get_final_time")
}

#' @export
get_final_time.ipysd <- function(o){
  o$model$components$final_time()
}

#-------------------------------------------------------------------------------------
#' Sets the initial time, final time, and timestep
#'
#' \code{set_time_valuesl()} sets the simulation times and DT
#'
#' @param o is the ipysd S3 object
#' @param init is the initial time
#' @param final is the final time
#' @param DT is the time step
#' @export
#' @examples
#'\dontrun{
#' target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
#' py <- pysd_connect()
#' py <- read_vensim(py, target)
#' set_time_values(py,0,10,0.5)
#'}
set_time_values <- function(o, init, final, DT){
  if(o$connected == F || is.null(o))
    stop("Error, no connection made. Need to call pysd_connect() first")
  if(o$loaded_model == F)
    stop("Error, no model loaded...")
  UseMethod("set_time_values")
}
#' @export
set_time_values.ipysd <- function(o, init, final, DT){
  init <- reticulate::r_to_py(list("Initial Time"=init))
  o$model$set_components(params = init)
  ft <- reticulate::r_to_py(list("Final Time"=final))
  o$model$set_components(params = ft)
  dt <- reticulate::r_to_py(list("Time Step"=DT))
  o$model$set_components(params = dt)

}

#-------------------------------------------------------------------------------------
#' Formats a table of variable names
#'
#' \code{get_doc()} Get mode variable names
#'
#' @param o is the ipysd S3 object
#' @return tibble
#' @export
#' @examples
#'\dontrun{
#' target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
#' py <- pysd_connect()
#' py <- read_vensim(py, target)
#' mdoc <- get_doc(py)
#'}
get_doc <- function(o){
  if(o$connected == F || is.null(o))
    stop("Error, no connection made. Need to call pysd_connect() befoe get_doc()")
  if(o$loaded_model == F)
    stop("Error, no model loaded...")
  UseMethod("get_doc")
}
#' @export
get_doc.ipysd <- function(o){
  tibble::as_data_frame(o$model$doc())
}

#-------------------------------------------------------------------------------------
#' Reloads the model from original mdl file
#'
#' \code{reload_model()} Reloads the model
#'
#' @param o is the ipysd S3 object
#' @return ipysd object
#' @export
#' @examples
#'\dontrun{
#' target <- system.file("models/vensim", "Population.mdl", package = "pysd2r")
#' py <- pysd_connect()
#' py <- read_vensim(py, target)
#' set_time_values(py,0,10,0.5)
#' py<-reload_model(py)
#'}
reload_model <- function(o){
  if(o$connected == F || is.null(o))
    stop("Error, no connection made. Need to call pysd_connect() first")
  if(o$loaded_model == F)
    stop("Error, no model loaded...")
  UseMethod("reload_model")
}
#' @export
reload_model.ipysd <- function(o){
  o$model$reload()
  o$reloaded_model <- T
  o$reload_time <- Sys.time()
  o
}
#-------------------------------------------------------------------------------------
#' @export
print.ipysd <- function(x,...){
  cat("================================================================================\n")
  cat("Printing details of ipysd interface object\n")
  cat(paste("Connected = ",x$connected,"\n"))
  cat(paste("Connected Time = ",x$connect_time,"\n"))
  cat(paste("Loaded Model = ",x$loaded_model,"\n"))
  if(x$reloaded_model==TRUE){
    cat(paste("Reloaded Model = ",x$reloaded_model,"\n"))
    cat(paste("Reloaded Time = ",x$reload_time,"\n"))
  }
  cat(paste("Model = ",x$model,"\n"))
  cat("================================================================================\n")
}
