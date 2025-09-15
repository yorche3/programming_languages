namespace src

module NumbersRecursive =

    let rec fibonacci n =
        match n with
        | n when n <= 1 -> n
        | _ -> fibonacci (n - 1) + fibonacci (n - 2)

    let rec factorial n =
        match n with
        | 1 -> 1
        | n -> n * factorial (n - 1)

    let rec sum_numbers n =
        match n with
        | 0 -> 0
        | n -> n + sum_numbers (n - 1)