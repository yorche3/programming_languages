namespace src

module NumbersIterative =

    let fibonacci n =
        let rec fibonacci_iter n i aux acc =
            match n with
            | n when n <= 1 -> n
            | n when i = n -> acc
            | _ -> fibonacci_iter n (i + 1) acc (acc + aux)
        fibonacci_iter n 2 1 1

    let factorial n = 
        let rec factorial_iter n acc =
            match n with
            | 1 -> acc
            | n -> factorial_iter (n - 1) (n * acc)
        factorial_iter n 1

    let sum_numbers n =
        let rec sum_numbers_iter n acc =
            match n with
            | 0 -> acc
            | n -> sum_numbers_iter (n - 1) (n + acc)
        sum_numbers_iter n 0