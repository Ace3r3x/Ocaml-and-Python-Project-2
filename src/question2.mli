(* This is an *interface* file, which specifies the types of top-level
   functions exported from its analogue for usage and testing: do not touch! *)

type bexp 
type env = (string * bool) list

val eval : bexp -> env -> bool

val varsOf : bexp -> string list

val allEnvs : string list -> env list

val isAlwaysTrue : bexp -> bool

val simplify : bexp -> env -> bexp
