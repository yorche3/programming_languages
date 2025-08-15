open System 

[<EntryPoint>]
let main argv =
    printf "Enter your name: "
    let name = System.Console.ReadLine()
    printfn "Hello, %s!" name
    0