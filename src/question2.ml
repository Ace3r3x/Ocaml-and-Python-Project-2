(** CW2, QUESTION 2 **)

(* a (2 marks) *)
(* This algebraic data type represents all possible components of a boolean expression:
   - Constants: True and False
   - Variables: Identified by strings
   - Unary operations: Logical NOT (Not)
   - Binary operations: Logical AND (And) and OR (Or) between two expressions *)

type bexp = 
  | True                (* Boolean constant true *)
  | False               (* Boolean constant false *)
  | Var of string       (* Variable with string identifier *)
  | Not of bexp         (* Logical NOT operation *)
  | And of bexp * bexp  (* Logical AND between two expressions *)
  | Or of bexp * bexp   (* Logical OR between two expressions *)



(* b (3 marks) *)
(* The environment is represented as a list of variable-value pairs, allowing for variable lookup during evaluation. *)
type env = (string * bool) list

(* Exception raised when a variable is not found in the environment *)
exception UndefinedVariable

(* eval : bexp -> env -> bool *)
(* Evaluates a boolean expression given an environment that maps variables to their boolean values.
   If an unknown variable is encountered, the UndefinedVariable exception is raised. *)
let rec eval (expr: bexp) (env: env) : bool =
  match expr with
  | True -> true
  | False -> false
  | Var v -> 
      
       (* Helper function: Searches for the value of a variable in the environment. *)
      let rec find_var v = function
        | [] -> raise UndefinedVariable  (* Raise exception if variable is not found *)
        | (name, value) :: rest -> 
            if name = v then value  (* Return the value if the variable matches *)
            else find_var v rest     (* Continue searching in the rest of the environment *)
      in
      find_var v env
  | Not e -> not (eval e env)  (* Recursively evaluate and negate the result *)
  | And (e1, e2) -> eval e1 env && eval e2 env  (* Evaluate both sides and return their conjunction *)
  | Or (e1, e2) -> eval e1 env || eval e2 env   (* Evaluate both sides and return their disjunction *)
 


(* c (4 marks) *)
(* Extracts all unique variables from a boolean expression, ensuring no duplicates in the result. *) 
(* varsOf : bexp -> string list *)
let varsOf (expr: bexp) : string list =
 (* Helper function: Removes duplicate elements from a list. *)
  let rec remove_duplicates lst =
    match lst with
    | [] -> []
    | h::t -> 
        
        (* Helper function: Filters out elements equal to h from the tail of the list. *)
        let filtered = 
          let rec filter acc = function
            | [] -> acc
            | x::xs -> 
                if x = h then filter acc xs  (* Skip duplicates *)
                else filter (x::acc) xs        (* Keep unique elements in accumulator *)
          in
          filter [] t
        in
        h :: remove_duplicates filtered  (* Include head and recursively remove duplicates from tail *)
  in
  
  (* Helper function: Collects all variables from an expression, including duplicates. *)
  let rec vars_helper expr =
    match expr with
    | True | False -> []  (* Constants do not contribute any variables *)
    | Var v -> [v]       (* Return single variable case as a list *)
    | Not e -> vars_helper e  (* Recurse on subexpression for negation *)
    | And (e1, e2) | Or (e1, e2) -> 
        let v1 = vars_helper e1 in
        let v2 = vars_helper e2 in
        v1 @ v2  (* Concatenate lists of variables from both sides *)
  in
  remove_duplicates (vars_helper expr)  (* Remove duplicates from collected variables *)



(* d (4 marks) *) 
(* Generates all possible variable assignments for a given list of variables. *)
(* allEnvs : string list -> env list *)
let rec allEnvs (vars: string list) : env list =
  match vars with
  | [] -> [[]]  (* Base case: an empty list of variables yields one empty environment *)
  | v::vs ->
      let rest = allEnvs vs in  (* Recursively generate environments for remaining variables *)
                                
      (* Helper function: Combines current variable with all possible assignments. *)
      let rec combine acc = function
        | [] -> acc
        | env::envs -> 
            let with_true = (v, true) :: env in   (* Create new environment with current variable set to true *)
            let with_false = (v, false) :: env in (* Create new environment with current variable set to false *)
            combine (with_true :: with_false :: acc) envs  (* Combine results into accumulator list *)
      in
      combine [] rest



(* e (2 marks) *)
(* Checks if a boolean expression is always true for all possible variable assignments. *)
(* isAlwaysTrue : bexp -> bool *)
let isAlwaysTrue (expr: bexp) : bool =
  let vars = varsOf expr in     (* Get all unique variables from the expression. *)
  let envs = allEnvs vars in    (* Generate all possible environments based on those variables. *)
  
  (* Helper function: Checks if the expression evaluates to true across all environments. *)
  let rec check_all = function
    | [] -> true  (* If no environments left, it means all were valid. *)
    | env::rest -> 
        if eval expr env then check_all rest  (* Continue checking remaining environments if current is valid. *)
        else false  (* Found at least one environment where expression is false. *)
  in
  check_all envs



(* f (5 marks) *)
(* Simplifies a boolean expression using partial variable assignments provided in an environment. *)
(* simplify : bexp -> env -> bexp *)
let rec simplify (expr: bexp) (env: env) : bexp =
  match expr with
  | True -> True  (* True remains unchanged when simplifying. *)
  | False -> False  (* False remains unchanged when simplifying. *) 
  | Var v ->
  
      (* Helper function: Looks up the value of a variable in the environment. *) 
      let rec lookup = function
        | [] -> Var v  (* If not found, return the variable itself. *) 
        | (name, value)::rest ->
            if name = v then  (* If found, return True or False based on its value. *)
              if value then True else False
            else lookup rest  (* Continue searching through remaining pairs. *) 
      in
      lookup env
  | Not e ->
      (match simplify e env with (* Simplify subexpression before negating it. *) 
       | True -> False (* NOT True simplifies to False. *) 
       | False -> True (* NOT False simplifies to True. *) 
       | e' -> Not e') (* Return simplified negation if neither case applies.*) 
  | And (e1, e2) ->
      (match (simplify e1 env, simplify e2 env) with
       | (False, _) -> False (* AND with False results in False regardless of other operand.*)
       | (_, False) -> False (* Same logic applies here.*)
       | (True, e) -> e (* AND with True results in other operand.*)
       | (e, True) -> e
       | (e1', e2') -> 
           if e1' = e2' then e1' (* If both operands are identical, return one instance.*)
           else And (e1', e2'))
  | Or (e1, e2) ->
      (match (simplify e1 env, simplify e2 env) with
       | (True, _) -> True (* OR with True results in True regardless of other operand.*)
       | (_, True) -> True (* Same logic applies here.*) 
       | (False, e) -> e (* OR with False results in other operand.*)
       | (e, False) -> e (* Same logic applies here.*) 
       | (e1', e2') -> 
           if e1' = e2' then e1' (* If both operands are identical, return one instance.*)
           else Or (e1', e2'));; (* Otherwise return combined OR expression.*)


(* Part a - No tests needed as it's type definition *)

(* Part b - Testing eval function *)
eval True [] = true;;
eval (Not True) [] = false;;
eval (And(True, False)) [] = false;;
eval (Or(False, True)) [] = true;;
eval (Var "x") [("x", true)] = true;;
eval (And(Var "x", Var "y")) [("x", true); ("y", false)] = false;;
try eval (Var "z") [] = false with UndefinedVariable -> true;;

(* Part c - Testing varsOf function *)
varsOf True = [];;
varsOf (Var "x") = ["x"];;
varsOf (And(Var "x", Var "y")) = ["x"; "y"];;
varsOf (Or(Var "x", Var "x")) = ["x"];;  (* Testing duplicate removal *)
varsOf (Not(And(Var "x", Var "y"))) = ["x"; "y"];;

(* Part d - Testing allEnvs function *)
allEnvs [] = [[]];;
allEnvs ["x"] = [[("x", true)]; [("x", false)]];;
List.length (allEnvs ["x"; "y"]) = 4;;
List.length (allEnvs ["x"; "y"; "z"]) = 8;;

(* Part e - Testing isAlwaysTrue function *)
isAlwaysTrue True = true;;
isAlwaysTrue False = false;;
isAlwaysTrue (Or(Var "x", Not(Var "x"))) = true;;  (* Tautology *)
isAlwaysTrue (And(Var "x", Not(Var "x"))) = false;;  (* Contradiction *)
isAlwaysTrue (Or(True, Var "x")) = true;;

(* Part f - Testing simplify function *)
simplify True [] = True;;
simplify (Var "x") [("x", true)] = True;;
simplify (And(True, Var "x")) [] = Var "x";;
simplify (Or(False, Var "x")) [] = Var "x";;
simplify (Not(False)) [] = True;;
simplify (And(Var "x", Var "x")) [] = Var "x";;


 (* Below is an example usage *)
let expr = And (Var "x", Or (Var "y", Not (Var "x")))
let env = [("x", true)]
let simplified = simplify expr env