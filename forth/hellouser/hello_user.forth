: main ( -- ) 
  cr " Enter your name: " type
  accept  \ read input into input buffer
  cr "Hello, " type
  input-buffer type  \ print the name
  cr
main