defmodule Elli.HTTPRequest do
  
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
  
  def get_arg( key, {__MODULE__, elli_req} ),               do: :elli_request.get_arg(key, elli_req)
  
  def get_arg( key, default, {__MODULE__, elli_req}),       do: :elli_request.get_header(key, default, elli_req)
  
  def get_args( {__MODULE__, elli_req} ),                   do: :elli_request.get_args(elli_req)
  
  def post_arg( key,{__MODULE__, elli_req} ),               do: :elli_request.post_arg(key,elli_req)
  
  def post_arg( key,default,{__MODULE__, elli_req} ),       do: :elli_request.post_arg(key,default,elli_req)
  
  def body_qs( {__MODULE__, elli_req} ),                    do: :elli_request.body_qs(elli_req)
  
  def headers( {__MODULE__, elli_req} ),                    do: :elli_request.headers(elli_req)
  
  def peer( {__MODULE__, elli_req} ),                       do: :elli_request.peer(elli_req)
  
  def method( {__MODULE__, elli_req} ),                     do: :elli_request.method(elli_req)
  
  def body( {__MODULE__, elli_req} ),                       do: :elli_request.body(elli_req)
  
  def get_range( {__MODULE__, elli_req} ),                  do: :elli_request.get_range(elli_req)
  
  def to_proplist( {__MODULE__, elli_req} ),                do: :elli_request.to_proplist(elli_req)
  
  
end