open Prelude

type lmdb_env
type lmdb_db
type lmdb_transaction

type openParams = {
  path: string,
  mapSize: int,
  maxDbs: int,
}
type openDbiParams = {
  name: string,
  create: bool,
}

@module("node-lmdb") @new external createLmdb: unit => lmdb_env = "Env"
@send external openEnv: (lmdb_env, openParams) => unit = "open"
@send external openDbi: (lmdb_env, openDbiParams) => lmdb_db = "openDbi"
@send external beginTransaction: lmdb_env => lmdb_transaction = "beginTxn"
@send external getString: (lmdb_transaction, lmdb_db, string) => Js.Nullable.t<string> = "getString"
@send external putString: (lmdb_transaction, lmdb_db, string, string) => unit = "putString"
@send external commit: lmdb_transaction => unit = "commit"

let exampleLmdb = () => {
  let env = createLmdb()

  openEnv(
    env,
    {
      path: pwd ++ "/__data",
      mapSize: 2 * 1024 * 1024,
      maxDbs: 3,
    },
  )

  let dbi = openDbi(
    env,
    {
      name: "myPrettyDatabase2",
      create: true, // will create if database did not exist
    },
  )

  let t = beginTransaction(env)

  let value = getString(t, dbi, "1")

  Js.log("1) =======")

  if Js.Nullable.isNullable(value) {
    Js.log("isNullable")
    Js.log(value)
    putString(t, dbi, "1", "|")
  } else {
    Js.log("NOT isNullable")
    Js.log(value)

    let newValue = value |> Js.Nullable.toOption |> Option.getWithDefault("|2")

    putString(t, dbi, "1", newValue ++ "|")
  }

  commit(t)

  Js.log("2) =======")
}
