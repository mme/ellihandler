defmodule Elli.HTTPRequest do
  use Bitwise

  def new(elli_req) do
    {__MODULE__, elli_req}
  end

  def chunk_ref( {__MODULE__, elli_req} ),                  do: :elli_request.chunk_ref(elli_req)

  def send_chunk( ref, data ),                              do: :elli_request.send_chunk(ref, data)

  def async_send_chunk( ref, data ),                        do: :elli_request.async_send_chunk(ref, data)

  def close_chunk( ref ),                                   do: :elli_request.close_chunk(ref)

  def path( {__MODULE__, elli_req} ),                       do: :elli_request.path(elli_req)

  def raw_path( {__MODULE__, elli_req} ),                   do: :elli_request.raw_path(elli_req)

  def query_str( {__MODULE__, elli_req} ),                  do: :elli_request.query_str(elli_req)

  def get_header( key, {__MODULE__, elli_req} ),            do: :elli_request.get_header(key, elli_req)

  def get_header( key, default, {__MODULE__, elli_req} ),   do: :elli_request.get_range(key, default, elli_req)

  def get_arg( key, {__MODULE__, elli_req} ),               do: arg_val(:elli_request.get_arg(key, elli_req))

  def get_arg( key, default, {__MODULE__, elli_req}),       do: arg_val(:elli_request.get_header(key, default, elli_req))

  def get_args( {__MODULE__, elli_req} ),                   do: :elli_request.get_args(elli_req)

  def post_arg( key,{__MODULE__, elli_req} ),               do: arg_val(:elli_request.post_arg(key,elli_req))

  def post_arg( key,default,{__MODULE__, elli_req} ),       do: arg_val(:elli_request.post_arg(key,default,elli_req))

  def body_qs( {__MODULE__, elli_req} ),                    do: :elli_request.body_qs(elli_req)

  def headers( {__MODULE__, elli_req} ),                    do: :elli_request.headers(elli_req)

  def peer( {__MODULE__, elli_req} ),                       do: :elli_request.peer(elli_req)

  def method( {__MODULE__, elli_req} ),                     do: :elli_request.method(elli_req)

  def body( {__MODULE__, elli_req} ),                       do: :elli_request.body(elli_req)

  def get_range( {__MODULE__, elli_req} ),                  do: :elli_request.get_range(elli_req)

  def to_proplist( {__MODULE__, elli_req} ),                do: :elli_request.to_proplist(elli_req)


  def arg_val(nil), do: nil
  def arg_val(a) when is_atom(a), do: a
  def arg_val(s), do: urldecode(s)

  # stolen from cowboy
  # https://github.com/extend/cowboy/blob/master/src/cowboy_http.erl
  def urldecode(s), do: urldecode(s, <<>>)

  def urldecode(<<?%, h, l, rest :: binary>>, acc) do
    g = unhex(h)
    m = unhex(l)
    if g == :error or m == :error do
      urldecode(<<h, h, rest :: binary>>, <<acc :: binary, ?%>>)
    else
      urldecode(rest, <<acc :: binary, bor(bsl(g,4), m)>>)
    end
  end


  def urldecode(<<?%, rest :: binary>>, acc), do: urldecode(rest, <<acc :: binary, ?%>>)
  def urldecode(<<?+, rest :: binary>>, acc), do: urldecode(rest, <<acc :: binary, ? >>)
  def urldecode(<<c, rest :: binary>>, acc), do: urldecode(rest, <<acc :: binary, c>>)
  def urldecode(<<>>, acc), do: acc


  def unhex(c) when c >= ?0 and c <= ?9, do: c - ?0
  def unhex(c) when c >= ?A and c <= ?F, do: c - ?A + 10
  def unhex(c) when c >= ?a and c <= ?f, do: c - ?a + 10
  def unhex(_), do: :error

end
