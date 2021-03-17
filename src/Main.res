open Prelude

let exampleTelegram = token => {
  let bot = Telegram.create(token, {polling: true})

  Telegram.on(bot, "message", msg => {
    Telegram.getChatAdministrators(bot, msg.chat.id) |> Promise.iter(admins => {
      Domain.execCommand(admins, msg) |> Array.iter(eff => {
        Js.log(j`Input: $msg\nOutput: $eff`)

        switch eff {
        | #AddAdmin(userId) =>
          Telegram.promoteChatMember(bot, msg.chat.id, userId, {can_manage_chat: true})
        | #Reply(msgId, text, delay) => {
            Telegram.sendMessage(bot, msg.chat.id, text, {reply_to_message_id: msgId}) |> ignore
            Promise.delay(delay) |> Promise.then_(_ => {
              Telegram.deleteMessage(bot, msg.chat.id, msgId)
            })
          }
        | #RemoveMessage(msgId, delay) =>
          Promise.delay(delay) |> Promise.then_(_ =>
            Telegram.deleteMessage(bot, msg.chat.id, msgId)
          )
        | #ChangeTitle(id, title) =>
          Telegram.setChatAdministratorCustomTitle(bot, msg.chat.id, id, title)
        } |> ignore
      })
    })
  })
}

exampleTelegram(argv[2])
