module Option = Js.Option
module Json = Js.Json
module Re = {
  include Js.Re

  let findCapture1 = (r, text) =>
    Js.Re.exec_(Js.Re.fromString(r), text) |> Option.andThen((. m) => {
      Js.Re.captures(m)[1] |> Js.Nullable.toOption
    })
}

module Duration = {
  type t = int
  let zero: t = 0
  let fromSeconds = (value: int): t => value
  let toSeconds = (value: t): int => value
  let add = (x: t, y: t): t => x + y
}

module Promise = {
  include Js.Promise

  let iter = (f, p) => Js.Promise.then_(r => {
      f(r)
      Js.Promise.resolve()
    }, p) |> ignore

  let delay = (d: Duration.t) =>
    Js.Promise.make((~resolve, ~reject as _) => {
      Js.Global.setTimeout(() => resolve(. ignore()), Duration.toSeconds(d)) |> ignore
    })
}

@send external toString: 'a => string = "toString"
@scope("process") @val external argv: array<string> = "argv"
@scope("process.env") @val external pwd: string = "PWD"
@scope("JSON") @val external parseJsonUnsafe: string => 'a = "parse"
