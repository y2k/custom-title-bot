open Prelude
open Jest

module TestApi = {
  let sendJsonCommand = (admins, cmd) =>
    Domain.execCommand(parseJsonUnsafe(admins), parseJsonUnsafe(cmd))
}

describe("Execute Telegram commands", () => {
  open Expect

  test("handle unknown command", () => {
    let result = TestApi.sendJsonCommand(
      `[]`,
      `{"message_id":3330,"from":{"id":2000000,"is_bot":false,"first_name":"Igor","username":"angmarr","language_code":"en"},"chat":{"id":1000000,"first_name":"Igor","username":"angmarr","type":"private"},"date":1616508994,"reply_to_message":{"message_id":3328,"from":{"id":3000000,"is_bot":false,"first_name":"Igor","username":"angmarr","language_code":"en"},"chat":{"id":1000000,"first_name":"Igor","username":"angmarr","type":"private"},"date":1616508813,"text":"test"},"text":"/unknown_command","entities":[{"offset":0,"length":13,"type":"bot_command"}]}`,
    )
    expect(result) |> toEqual([])
  })

  test("success add admin", () => {
    let result = TestApi.sendJsonCommand(
      `[{"user":{"id":2000000,"is_bot":false,"first_name":"Igor","username":"angmarr","language_code":"en"},"status":"creator","is_anonymous":false}]`,
      `{"message_id":3330,"from":{"id":2000000,"is_bot":false,"first_name":"Igor","username":"angmarr","language_code":"en"},"chat":{"id":1000000,"first_name":"Igor","username":"angmarr","type":"private"},"date":1616508994,"reply_to_message":{"message_id":3328,"from":{"id":3000000,"is_bot":false,"first_name":"Igor","username":"angmarr","language_code":"en"},"chat":{"id":1000000,"first_name":"Igor","username":"angmarr","type":"private"},"date":1616508813,"text":"test"},"text":"/add_as_admin","entities":[{"offset":0,"length":13,"type":"bot_command"}]}`,
    )
    expect(result) |> toEqual([#AddAdmin(3000000), #RemoveMessage(3330, Duration.zero)])
  })

  test("try add admin without permissions", () => {
    let result = TestApi.sendJsonCommand(
      `[{"user":{"id":2000000,"is_bot":false,"first_name":"Igor","username":"angmarr","language_code":"en"},"status":"admin","is_anonymous":false}]`,
      `{"message_id":3330,"from":{"id":2000000,"is_bot":false,"first_name":"Igor","username":"angmarr","language_code":"en"},"chat":{"id":1000000,"first_name":"Igor","username":"angmarr","type":"private"},"date":1616508994,"reply_to_message":{"message_id":3328,"from":{"id":3000000,"is_bot":false,"first_name":"Igor","username":"angmarr","language_code":"en"},"chat":{"id":1000000,"first_name":"Igor","username":"angmarr","type":"private"},"date":1616508813,"text":"test"},"text":"/add_as_admin","entities":[{"offset":0,"length":13,"type":"bot_command"}]}`,
    )
    expect(result) |> toEqual([
      #Reply(3330, "Error b8cd21305443", Duration.fromSeconds(5)),
      #RemoveMessage(3330, Duration.fromSeconds(5)),
    ])
  })

  test("success change title", () => {
    let result = TestApi.sendJsonCommand(
      `[{"user":{"id":2000000,"is_bot":false,"first_name":"Igor","username":"angmarr","language_code":"en"},"status":"admin","is_anonymous":false}]`,
      `{"message_id":3316,"from":{"id":2000000,"is_bot":false,"first_name":"Igor","username":"angmarr","language_code":"en"},"chat":{"id":1000000,"first_name":"Igor","username":"angmarr","type":"private"},"date":1616352879,"text":"/change_title new_title"}`,
    )
    expect(result) |> toEqual([
      #ChangeTitle(2000000, "new_title"),
      #RemoveMessage(3316, Duration.zero),
    ])
  })

  test("unsuccess change title", () => {
    let result = TestApi.sendJsonCommand(
      `[]`,
      `{"message_id":3316,"from":{"id":2000000,"is_bot":false,"first_name":"Igor","username":"angmarr","language_code":"en"},"chat":{"id":1000000,"first_name":"Igor","username":"angmarr","type":"private"},"date":1616352879,"text":"/change_title new_title"}`,
    )
    expect(result) |> toEqual([
      #Reply(3316, "Error 6ca54ade3247", Duration.fromSeconds(5)),
      #RemoveMessage(3316, Duration.fromSeconds(5)),
    ])
  })
})
