program hello_user
  implicit none
  character(len=100) :: name

  print *, "Enter your name:"
  read *, name

  print *, "Hello, ", trim(name), "!"
end program hello_user