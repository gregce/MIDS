require("Quandl")         # Functions to access Quandl's database
require("lattice")        # Base graph functions
require("latticeExtra")   # Layer graph functions

# Load data from Quandl
my.data <- Quandl("TPC/HIST_RECEIPT", start_date="1945-12-31", end_date="2013-12-31")

# Make Names of Columns Syntactically Valid
names(my.data) <- make.names(names(my.data))
