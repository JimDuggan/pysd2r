# devtools::load_all()
library(pysd2r)

# make the link thorugh reticulate
py <- pysd2r::pysd_connect()

# load a model
py <- pysd2r::read_vensim(py, "tests/vensim/Population.mdl")

# Getting some model info
message(paste("Initial Time =",pysd2r::get_initial_time(py)))
message(paste("Final Time =",pysd2r::get_final_time(py)))
message(paste("Time Step =",pysd2r::get_timestep(py)))
message(paste("SAVEPER =",pysd2r::get_saveper(py)))

# run the model
out <- pysd2r::run_model(py)

# changing a parameter
l <- list("Growth Fraction"=0.091)
pysd2r::set_components(py,l)
out1 <- pysd2r::run_model(py)

# setting an initial stock through its parameter
l <- list("Initial Population"=9999)
pysd2r::set_components(py,l)
out3 <- pysd2r::run_model(py)




# Checking a change in the time step
l <- list("TIME STEP"=1)
pysd2r::set_components(py,l)
out4 <- pysd2r::run_model(py)



