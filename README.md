# TwitchDown
Use Twitch API To Download Vedio and Chat.

## Usage
### Get Client ID
[Register your Application](https://www.twitch.tv/kraken/oauth2/clients/new)

- Name: Type what you want
- Redirect URI: Type `http://localhost` for testing
- Application Category: Random choose one

Get the client ID and modify `vedio.rb`'s `client_id` to your `client_id`

```ruby
# vedio.rb
# client_id = ''
client_id = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
```

### Download

download vedio and chat which default path at `vedio/date_vedioId`

```sh
ruby download.rb <url>
```

Downloaded files

- m3u: vod quality list
- m3u8: vod chunked list
- ts: vedio file
- txt: vod chat list

## Tools
### Concat Ts Files

if you want to concat different part of ts files

```sh
ruby ts_concat.rb <output.ts> <input1.ts> <input2.ts> ...
```
