open Prelude

include TelegramTypes

type t_bot
type telegram_option = {polling: bool}

@new @module external create: (string, telegram_option) => t_bot = "node-telegram-bot-api"
@send external on: (t_bot, string, msg => unit) => unit = "on"
@send
external getChatAdministrators: (t_bot, int) => Promise.t<array<user_admin>> =
  "getChatAdministrators"
@send external getChatMember: (t_bot, int, string) => Promise.t<user> = "getChatMember"
@send
external setChatAdministratorCustomTitle: (t_bot, int, int, string) => Promise.t<unit> =
  "setChatAdministratorCustomTitle"
@send external deleteMessage: (t_bot, int, int) => Promise.t<unit> = "deleteMessage"

type sendMessageOptions = {reply_to_message_id: int}

@send
external sendMessage: (t_bot, int, string, sendMessageOptions) => Promise.t<unit> = "sendMessage"

type promoteOptions = {can_manage_chat: bool}

@send
external promoteChatMember: (t_bot, int, int, promoteOptions) => Promise.t<unit> =
  "promoteChatMember"
