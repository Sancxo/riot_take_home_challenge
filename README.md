# RiotTakeHomeChallenge

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

This API only supports `POST` requests, here is the four routes you can use:
- `/encrypt` => can receive any JSON body and returns the same body but with every values at depth 1 encrypted with `base64`.
- `/decrypt` => can receive a JSON body with values at depth 1 encrypted with `base64` and returns the same body but with decrypted values. If a value is not encrypted with `base64`, it is returned unchanged
- `/sign` => can receive any JSON body and returns and JSON body with a `signature` key and the body signed with `hmac` as value.
- `/verify` => can receive a JSON with `data` and `signature` keys, containing respectively a JSON payload and a signature, and returns `204 No Content` HTTP code if the signature matches with the JSON payload. If not, it reutrns `400 Bad Request` HTTP code.

Some examples: 

```json
// POST /encrypt input
{"hello": "world"} 
// POST /encrypt output
{"hello": "IndvcmxkIg=="}

// POST /decrypt input
{"hello": "IndvcmxkIg=="}
// POST /decrypt output
{"hello": "world"} 

// POST /sign input
{"hello": "world"}
// POST /sign output
{"signature": "azertyuiop..."}

// POST /verify input
{"data": {"hello": "world"}, "signature": "azertyuiop..."}
// POST /verify output
// 204 No Content
```

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
