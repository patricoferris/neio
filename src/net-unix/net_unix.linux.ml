type _ socket =
  | Listening : Eio_unix.Fd.t -> Net__Net_intf.listening socket
  | Streaming : Eio_unix.Fd.t -> Net__Net_intf.streaming socket

let connect ~sw stream =
  let domain = Eio_unix.Net.socket_domain_of stream in
  let socket =
    Unix.socket domain Unix.SOCK_STREAM 0
    |> Eio_unix.Fd.of_unix ~sw ~seekable:false ~close_unix:true
  in
  Eio_linux.Low_level.connect socket (Eio_unix.Net.sockaddr_to_unix stream);
  Streaming socket

let listen ~reuse_addr ~reuse_port ~backlog ~sw stream =
  let sock =
    Eio_linux.Low_level.listen ~reuse_addr ~reuse_port ~backlog ~sw stream
  in
  Listening sock

let accept ~sw (Listening sock) =
  let fd, sockaddr = Eio_linux.Low_level.accept ~sw sock in
  (Streaming fd, Eio_unix.Net.sockaddr_of_unix_stream sockaddr)

let fd_of_socket (type a) : a socket -> Eio_unix.Fd.t = function
  | Listening sock -> sock
  | Streaming sock -> sock

let flow_of_fd = Eio_linux.flow
