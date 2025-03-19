(* This is an *interface* file, which specifies the types of top-level
   functions exported from its analogue for usage and testing: do not touch! *)

type pos = int * int
type move = NE | NW | SE | SW

val isValidSeq : pos -> pos list -> move list -> bool

val allMoves : pos -> pos list -> move list list
