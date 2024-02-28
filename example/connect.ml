let loopback = `Tcp (Eio.Net.Ipaddr.V4.loopback, 8787)

let () =
  Eio_main.run @@ fun _ ->
  Eio.Switch.run @@ fun sw ->
  Eio.traceln "Connecting to %a" Eio.Net.Sockaddr.pp loopback;
  let streaming_socket = Net_unix.connect ~sw loopback in
  let flow = Net_unix.fd_of_socket streaming_socket |> Net_unix.flow_of_fd in
  Eio.Flow.copy_string "Hello from neio!" flow;
  Eio.Flow.shutdown flow `Send;
  Eio.traceln "Response: %s" (Eio.Flow.read_all flow)
