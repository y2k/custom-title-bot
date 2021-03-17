type msg_from = {id: int}
type msg_chat = {id: int}
type user = {id: int}
type user_admin = {user: user, status: string}

type rec msg = {
  message_id: int,
  text: string,
  from: msg_from,
  chat: msg_chat,
  reply_to_message: option<msg>,
  entities: array<string>,
}
