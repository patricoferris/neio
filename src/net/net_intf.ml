type listening = Listening
type streaming = Streaming

module type S = sig
  type _ socket

  val connect : sw:Eio.Switch.t -> Eio.Net.Sockaddr.stream -> streaming socket
  (** [connect ~sw t addr] is a new socket connected to remote address [addr].

    The new socket will be closed when [sw] finishes, unless closed manually first. *)

  val listen :
    reuse_addr:bool ->
    reuse_port:bool ->
    backlog:int ->
    sw:Eio.Switch.t ->
    Eio.Net.Sockaddr.stream ->
    listening socket
  (** [listen ~sw ~backlog t addr] is a new listening socket bound to local address [addr].

        The new socket will be closed when [sw] finishes, unless closed manually first.

        On platforms that support this, passing port [0] will bind to a random port.

        For (non-abstract) Unix domain sockets, the path will be removed afterwards.

        @param backlog The number of pending connections that can be queued up (see listen(2)).
        @param reuse_addr Set the {!Unix.SO_REUSEADDR} socket option.
                        For Unix paths, also remove any stale left-over socket.
        @param reuse_port Set the {!Unix.SO_REUSEPORT} socket option. *)

  val accept :
    sw:Eio.Switch.t ->
    listening socket ->
    streaming socket * Eio.Net.Sockaddr.stream
  (** [accept ~sw socket] waits until a new connection is ready on [socket] and returns it.

        The new socket will be closed automatically when [sw] finishes, if not closed earlier.
        If you want to handle multiple connections, consider using {!accept_fork}
        instead. *)
end

module type Intf = sig
  type listening
  type streaming

  module type S = S
end
