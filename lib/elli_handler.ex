defmodule Elli.Handler do
  
  defmacro __using__(_opts) do
    
    quote do
      @before_compile Elli.Handler
      @behaviour :elli_handler
      
      def handle(elli_req,args) do
        req = Elli.HTTPRequest.new elli_req
        
        case args[:prefix] do
          nil            -> handle(req.method, req.path, req)
          string_prefix  -> prefix = (Enum.filter String.split(string_prefix, "/"), &1 != "")
                            if (Enum.take req.path, length(prefix)) == prefix do
                              handle(req.method, (Enum.drop req.path, length(prefix)), req)
                            else
                              :ignore
                            end
        end
        
      end

      import Elli.Handler
      
    end
  end

  defp split_path(path) do
    Enum.filter String.split(path, "/"), &( &1 != "" )
  end
  
  defp compile_path(path) do
    Enum.map(split_path(path), &compile_pattern(&1))
  end
  
  defp compile_pattern(pat) do
    len = (String.length pat)
    if len >= 2 and (String.at pat, 0) == ":" do
      atom = binary_to_atom(String.slice pat,1,len-1)
      quote do var!(unquote(atom)) end
    else
      pat
    end
  end
  
  defp compile_params(nil), do: nil
  defp compile_params({:with_params, _, params}), do: Enum.map(params, &compile_param(&1))
  
  defp compile_param({param,_,_}) do
    param_binary = atom_to_binary(param)
    quote hygiene: [vars: false] do
      var!(unquote(param)) = req.get_arg(unquote(param_binary)) 
      if var!(unquote(param)) == :undefined do 
        halt! bad_request
      end
    end
  end
    
  defmacro get(path, params // nil, do: code) do
    quote do
      match :GET, unquote(path), unquote(params) do
        unquote(code)
      end
    end
  end
  
  defmacro post(path, params // nil, do: code) do
    quote do
      match :POST, unquote(path), unquote(params) do
        unquote(code)
      end
    end
  end
  
  defmacro put(path, params // nil, do: code) do
    quote do
      match :PUT, unquote(path), unquote(params) do
        unquote(code)
      end
    end
  end
  
  defmacro delete(path, params // nil, do: code) do
    quote do
      match :DELETE, unquote(path), unquote(params) do
        unquote(code)
      end
    end
  end
  
  defmacro match(method, path, params // nil, do: code) do
    params = compile_params(params)
    quote hygiene: [vars: false] do
      def handle(unquote(method), unquote(compile_path path), req) do
        req # don't complain about unused variable
        unquote(params)
        unquote(code)
      end
    end
  end
  
  defmacro event(name, do: code) do
    quote hygiene: [vars: false] do
      def handle_event(unquote(name), data, args) do
        data
        args
        unquote(code)
      end
    end
  end
  
  def with_headers(added_headers, {status, headers, body}),         do: {status, headers ++ added_headers, body}
  def http_ok,                                                      do: {:ok, [], "Ok"}
  def http_ok(body) when is_binary(body),                           do: {:ok, [], body}
  def http_ok(:json),                                               do: http_ok(:json, "{\"status\":\"ok\"}")
  def http_ok(:html),                                               do: http_ok(:html, "Ok")
  def http_ok(:text),                                               do: http_ok(:text, "Ok")
  def http_ok(:json, body),                                         do: http_ok("application/json", body)
  def http_ok(:html, body),                                         do: http_ok("text/html", body)
  def http_ok(:text, body),                                         do: http_ok("text/plain", body)
  def http_ok(content_type, body),                                  do: with_headers([{"Content-type", content_type}] , http_ok(body))
  def http_not_found(body // "Not Found"),                          do: {404, [], body}
  def http_permission_denied(body // "Permission denied"),          do: {403, [], body}
  def http_internal_server_error(body // "Internal Server Error"),  do: {500, [], body}
  def bad_request(body // "Bad Request"),                           do: {400, [], body}

  def elli_ignore, do: :ignore
  def halt!(res), do: throw(res)
  
  defmacro __before_compile__(_env) do
    quote do
      def handle(_, _, req), do: elli_ignore
      def handle_event(_, _, _), do: :ok
    end
  end
  
end
