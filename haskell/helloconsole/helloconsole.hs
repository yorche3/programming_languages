main = do
  putStrLn "¿Cuál es tu nombre?"
  name <- getLine
  putStrLn $ "Hola " ++ name  