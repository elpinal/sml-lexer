signature POSITION = sig
  type position

  val initial : position
  val next : char -> position -> position
end

functor Reader (X : POSITION) :> sig
  type t

  exception EOF

  val new : string -> t

  val peek : t -> char (* EOF *)
  val peek_after : t -> int -> char (* EOF *)

  val peek_option : t -> char option

  val proceed : t -> char -> unit
  val next : t -> char (* EOF *)

  val pos : t -> X.position
end = struct
  type t =
    { src : CharVector.vector
    , position : X.position ref
    , offset : int ref
    }

  exception EOF

  fun new s =
  let
    val v = s
  in
    { src = v
    , position = ref X.initial
    , offset = ref 0
    }
  end

  fun peek_after (l : t) n =
    CharVector.sub (#src l, n + !(#offset l))
    handle Subscript => raise EOF

  fun peek (l : t) = peek_after l 0

  fun peek_option l = SOME (peek l)
    handle EOF => NONE

  fun proceed (l : t) c =
    #offset l := !(#offset l) + 1
    before
    #position l := X.next c (!(#position l))

  fun next (l : t) =
  let
    val c = peek l
  in
    proceed l c; c
  end

  fun pos (l : t) = !(#position l)
end
