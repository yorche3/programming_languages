puts -nonewline "Please enter your name: "
flush stdout
set name [gets stdin]
puts "Hello, $name!"