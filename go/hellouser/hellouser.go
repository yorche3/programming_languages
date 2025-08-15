package main

import "fmt"

func main() {
	var name string
	fmt.Print("Enter your name: ")
	fmt.Scanf("%s", &name)
	message := fmt.Sprintf("Hello, %s!", name)
	fmt.Println(message)
}
