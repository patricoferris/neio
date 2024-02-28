let loopback = `Tcp (Eio.Net.Ipaddr.V4.loopback, 8080)

let () =
  Eio_main.run @@ fun _ ->
  Eio.Switch.run @@ fun sw ->
  let listener =
    Net_unix.listen ~reuse_addr:true ~reuse_port:true ~backlog:5 ~sw loopback
  in
  Eio.traceln "Listening on %a" Eio.Net.Sockaddr.pp loopback;
  while true do
    let sock, _ = Net_unix.accept ~sw listener in
    let flow = Net_unix.fd_of_socket sock |> Net_unix.flow_of_fd in
    Eio.traceln "Read: %s" (Eio.Flow.read_all flow);
    Eio.Flow.copy_string "Good to connect!" flow;
    Eio.Flow.shutdown flow `Send
  done
