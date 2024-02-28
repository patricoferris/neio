include Net.S

val fd_of_socket : _ socket -> Eio_unix.Fd.t

val flow_of_fd :
  Eio_unix.Fd.t ->
  [< `Close
  | `File
  | `Flow
  | `Platform of [ `Generic | `Unix ]
  | `R
  | `Shutdown
  | `Socket
  | `Stream
  | `Unix_fd
  | `W ]
  Eio.Std.r
