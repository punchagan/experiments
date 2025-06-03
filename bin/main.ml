let writer accum data =
  Buffer.add_string accum data ;
  String.length data

let showContent content =
  Printf.printf "%s" (Buffer.contents content) ;
  flush stdout

let showInfo connection =
  Printf.printf "Time: %f\nURL: %s\n"
    (Curl.get_totaltime connection)
    (Curl.get_effectiveurl connection)

let _getContent connection url =
  Curl.set_url connection url ;
  Curl.perform connection

let () =
  print_endline "Hello, World!" ;
  (* Zarith (GMP) *)
  let n1 = Z.of_string "12345678901234567890" in
  let n2 = Z.of_string "98765432109876543210" in
  let sum = Z.add n1 n2 in
  Printf.printf "GMP (Zarith) BigInt Sum: %s\n" (Z.to_string sum) ;
  (* From ocurl/examples/ocurl.ml *)
  Curl.global_init Curl.CURLINIT_GLOBALALL ;
  (let result = Buffer.create 16384 and errorBuffer = ref "" in
   try
     let connection = Curl.init () in
     Curl.set_errorbuffer connection errorBuffer ;
     Curl.set_writefunction connection (writer result) ;
     Curl.set_followlocation connection true ;
     Curl.set_url connection "https://opam.ocaml.org/packages/curl/" ;
     Curl.perform connection ;
     showContent result ;
     showInfo connection ;
     Curl.cleanup connection
   with
   | Curl.CurlException (_reason, _code, _str) ->
       Printf.fprintf stderr "Error: %s\n" !errorBuffer
   | Failure s ->
       Printf.fprintf stderr "Caught exception: %s\n" s ) ;
  Curl.global_cleanup ()
