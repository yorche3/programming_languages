#This is for R interactive use
#name <- readline(prompt = "Enter your name: ")
# This is for command line use
# Usage: Rscript hellouser.r <name>
# Example: Rscript hellouser.r John
args <- commandArgs(trailingOnly = TRUE)
name <- args[1]
print(paste0("Hello, ", name, "!"))