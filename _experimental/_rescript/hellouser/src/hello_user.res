type readlineInterface

@module("readline") @new external createInterface: (
  ~input: Js.t<'a>,
  ~output: Js.t<'b>,
) => readlineInterface = "createInterface"

@send external on: (readlineInterface, @string [#line(string => unit) | #close(unit => unit)]) => unit = "on"
@send external question: (readlineInterface, string, string => unit) => unit = "question"
@send external close: readlineInterface => unit = "close"

@module("node:process")
external stdin: Js.t<{..}> = "stdin"

@module("node:process")
external stdout: Js.t<{..}> = "stdout"

let run = () => {
  let rl = createInterface(~input=stdin, ~output=stdout)

  question(rl,"Enter your name: ", name => {
    Js.log2("Hello, ", name)
    close(rl)
  })
}

run()