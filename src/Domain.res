open Prelude
open TelegramTypes

let isOwner = (admins, userId) =>
  admins |> Array.exists(x => x.status == "creator" && x.user.id == userId)

let isAdmin = (admins, userId) => admins |> Array.exists(x => x.user.id == userId)

let showError = (msg, error) => [
  #Reply(msg.message_id, `Error ${error}`, Duration.fromSeconds(5)),
  #RemoveMessage(msg.message_id, Duration.fromSeconds(5)),
]

let execCommand = (admins, msg) =>
  switch Re.exec_(Re.fromString("/add_as_admin"), msg.text) {
  | Some(_) =>
    switch msg.reply_to_message {
    | Some(reply) =>
      switch isOwner(admins, msg.from.id) {
      | true => [#AddAdmin(reply.from.id), #RemoveMessage(msg.message_id, Duration.zero)]
      | false => showError(msg, "b8cd21305443")
      }
    | None => showError(msg, "4d08c20ebabf")
    }
  | None =>
    switch Re.findCapture1("/change_title ([a-z_-]+)", msg.text) {
    | Some(title) =>
      switch isAdmin(admins, msg.from.id) {
      | true => [#ChangeTitle(msg.from.id, title), #RemoveMessage(msg.message_id, Duration.zero)]
      | false => showError(msg, "6ca54ade3247")
      }
    | None => []
    }
  }
