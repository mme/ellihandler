elli-http-handler
================================

*simple http handling with elli and elixir*


Quick start
-------------------------

```elixir
defmodule Handler do
  use Elli.HTTPHandler
  
  get "/" do
    http_ok "Hello world"
  end
  
end

{ :ok, pid } = :elli.start_link [callback: Handler, port: 3000]

```

Point your browser to [http://localhost:3000/](http://localhost:3000/)

Usage
-------------------------

use _get_, _post_, _put_ or _delete_ to match http requests methods
```elixir
post "/hello" do
  http_ok "Hello post"
end
```

or use _match_ to match all methods
```elixir
match method, "/rest" do
 if method == :DELETE do
   http_permission_denied
 else
   http_ok
 end
end
```

parameters become available as variables
```elixir
get "/hello/:name" do
 http_ok("Hello #{name}!")
end
```

License
-------------------------
Copyright (c) 2013, Markus Ecker

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



