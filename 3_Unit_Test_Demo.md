# Unit Test / Demo

## Objective
create a dir named unit_test and inside create a project that has a unit test for Calculator class/module/namespace with add and subtract methods/functions.

## Goal
- Create a project structure with source and test directories.

## Structure
```text
unit_test
└── demo
    ├── src
    |   └── calculator.ext
    └── test
        └── test.ext
```

## Example Code

```pseudocode
container Calculator
    .- add(a, b)
        return a + b
    .- subtract(a, b)
        return a - b
end container
```

```pseudocode
test Calculator
    assert Calculator.add(2, 3) == 5
    assert Calculator.subtract(5, 3) == 2
end test
```