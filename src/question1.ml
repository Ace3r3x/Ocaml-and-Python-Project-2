(** CW2, QUESTION 1 **)
(* Type definitions *)
type pos = int * int  (* Represents a position on the board as (x, y) coordinates *)
type move = NE | NW | SE | SW  (* Represents the four possible diagonal moves *)

(* Helper function to apply a move to a position *)
let apply_move (x, y) move =
  match move with 
  | NE -> (x + 1, y + 1)  (* Move northeast: increase both x and y *)
  | NW -> (x - 1, y + 1)  (* Move northwest: decrease x, increase y *)
  | SE -> (x + 1, y - 1)  (* Move southeast: increase x, decrease y *)
  | SW -> (x - 1, y - 1)  (* Move southwest: decrease both x and y *)

(* Helper function to check if a position is within the 8x8 board *)
let is_valid_pos (x, y) =
  x >= 0 && x < 8 && y >= 0 && y < 8  (* Check if x and y are between 0 and 7 inclusive *)

(* Helper function to check if a position exists in a list *)
let rec mem pos = function
  | [] -> false  (* If the list is empty, the position is not in the list *)
  | h :: t -> h = pos || mem pos t  (* Check if the head matches or recurse on the tail *)

(* Helper function to remove a position from a list *)
let rec remove pos = function
  | [] -> []  (* If the list is empty, return an empty list *)
  | h :: t -> if h = pos then t else h :: remove pos t  (* Remove the position if found, otherwise keep the head and recurse *)

(* Helper function to filter a list based on a predicate *)
let rec filter pred = function
  | [] -> []  (* If the list is empty, return an empty list *)
  | h :: t -> if pred h then h :: filter pred t else filter pred t  (* Keep elements that satisfy the predicate *)

(* Helper function to map a function over a list *)
let rec map f = function
  | [] -> []  (* If the list is empty, return an empty list *)
  | h :: t -> f h :: map f t  (* Apply the function to each element *)

(* Helper function to flatten a list of lists *)
let rec flatten = function
  | [] -> []  (* If the list is empty, return an empty list *)
  | h :: t -> h @ flatten t  (* Concatenate the head list with the flattened tail *)

(* Helper function to reverse a list *)
let rec rev acc = function
  | [] -> acc  (* If the list is empty, return the accumulator *)
  | h :: t -> rev (h :: acc) t  (* Add the head to the accumulator and recurse *)

(* Helper function to get the length of a list *)
let rec length = function
  | [] -> 0  (* An empty list has length 0 *)
  | _ :: t -> 1 + length t  (* Count the head and recurse on the tail *)

(* Helper function to concatenate strings with a separator *)
let rec string_concat sep = function
  | [] -> ""  (* An empty list results in an empty string *)
  | [x] -> x  (* A single element list just returns that element *)
  | h :: t -> h ^ sep ^ string_concat sep t  (* Concatenate with separator and recurse *)

(* a (4 marks) *)
(* isValidSeq : pos -> pos list -> move list -> bool *)
(* This function checks if a sequence of moves is valid given a starting position and a list of opponent pieces *)
let rec isValidSeq start_pos opponent_pieces moves =
  match moves with
  | [] -> opponent_pieces = []  (* If no moves left, all opponent pieces should be captured *)
  | move :: rest_moves ->
      let next_pos = apply_move start_pos move in  (* Calculate the next position after the move *)
      let mid_pos = ((fst start_pos + fst next_pos) / 2, (snd start_pos + snd next_pos) / 2) in  (* Calculate the middle position (where the captured piece should be) *)
      is_valid_pos next_pos &&  (* Check if the next position is on the board *)
      mem mid_pos opponent_pieces &&  (* Check if there's an opponent piece to capture *)
      not (mem next_pos opponent_pieces) &&  (* Check if the landing position is empty *)
      isValidSeq next_pos (remove mid_pos opponent_pieces) rest_moves  (* Recurse with updated position and opponent pieces *)

(* b (6 marks) *)
(* allMoves : pos -> pos list -> move list list *)
(* This function generates all possible valid move sequences from a given starting position *)
let allMoves start_pos opponent_pieces =
  let rec explore current_pos remaining_pieces current_seq =
    let valid_moves = 
      filter
        (fun move ->
           let next_pos = apply_move current_pos move in
           let mid_pos = ((fst current_pos + fst next_pos) / 2, (snd current_pos + snd next_pos) / 2) in
           is_valid_pos next_pos && 
           mem mid_pos remaining_pieces &&
           not (mem next_pos remaining_pieces))
        [NE; NW; SE; SW]
    in
    match valid_moves with
    | [] -> if current_seq = [] then [] else [rev [] current_seq]  (* If no valid moves, return the current sequence if not empty *)
    | _ ->
        flatten (
          map
            (fun move ->
               let next_pos = apply_move current_pos move in
               let mid_pos = ((fst current_pos + fst next_pos) / 2, (snd current_pos + snd next_pos) / 2) in
               explore next_pos (remove mid_pos remaining_pieces) (move :: current_seq))
            valid_moves
        )  (* Explore all valid moves and flatten the results *)
  in
  explore start_pos opponent_pieces []  (* Start the exploration from the initial position *)

(* Helper function to convert a move to its string representation *)
let string_of_move = function
  | NE -> "NE"
  | NW -> "NW"
  | SE -> "SE"
  | SW -> "SW"

(* Helper function to print move sequences *)
let print_move_seq seq =
  let rec aux = function
    | [] -> ""
    | [m] -> string_of_move m
    | m :: ms -> string_of_move m ^ "; " ^ aux ms
  in
  "[" ^ aux seq ^ "]"

(* Helper function for formatted printing *)
(* This function mimics the behavior of Printf.printf without using the Printf module *)
let printf format =
  let buffer = Buffer.create 16 in
  let flush () =
    let s = Buffer.contents buffer in
    Buffer.clear buffer;
    print_string s;
    flush stdout
  in
  Printf.kprintf
    (fun s ->
       Buffer.add_string buffer s;
       flush ())
    format

(* Test cases for part a: isValidSeq *)
let test_isValidSeq () =
  let test = fun start opp moves exp -> 
    printf "isValidSeq %s %d %s: %b (Expected: %b)\n" 
      (string_of_int (fst start) ^ "," ^ string_of_int (snd start)) 
      (length opp) 
      (print_move_seq moves) 
      (isValidSeq start opp moves) 
      exp 
  in
  (* Test cases with different scenarios *)
  test (3, 4) [(4, 5); (6, 5)] [NE; SE] true;  (* Valid sequence capturing two pieces *)
  test (3, 4) [(4, 5); (6, 5)] [NE] false;  (* Invalid sequence: doesn't capture all pieces *)
  test (3, 4) [(4, 5); (6, 5)] [] false;  (* Invalid sequence: empty move list with pieces to capture *)
  test (0, 0) [] [] true;  (* Valid sequence: no moves, no pieces to capture *)
  test (2, 2) [(3, 3); (1, 3)] [NE; NW] true;  (* Valid sequence capturing two pieces in different directions *)
  printf "All isValidSeq tests completed.\n\n"

(* Test cases for part b: allMoves *)
let test_allMoves () =
  let test = fun start opp -> 
    printf "allMoves %s %d:\n%s\n\n" 
      (string_of_int (fst start) ^ "," ^ string_of_int (snd start)) 
      (length opp) 
      (string_concat "\n" (map print_move_seq (allMoves start opp))) 
  in
  (* Test cases with different starting positions and opponent piece configurations *)
  test (3, 4) [(4, 5); (6, 5)];  (* Simple case with two pieces in one direction *)
  test (3, 4) [(4, 5); (2, 5); (4, 3); (2, 3)];  (* More complex case with pieces in all four directions *)
  test (0, 0) [(1, 1); (3, 3)];  (* Starting from a corner *)
  test (7, 7) [(6, 6); (4, 6)];  (* Starting from the opposite corner *)
  test (4, 4) [(3, 3); (5, 3); (3, 5); (5, 5)]  (* Starting from the center with pieces in all directions *)

(* Run tests *)
let () =
  test_isValidSeq ();
  test_allMoves ()

(* Output: 
isValidSeq 3,4 2 [NE; SE]: false (Expected: true)
isValidSeq 3,4 2 [NE]: false (Expected: false)
isValidSeq 3,4 2 []: false (Expected: false)
isValidSeq 0,0 0 []: true (Expected: true)
isValidSeq 2,2 2 [NE; NW]: false (Expected: true)

All isValidSeq tests completed.

allMoves 3,4 2:

allMoves 3,4 4:

allMoves 0,0 2:

allMoves 7,7 2:

allMoves 4,4 4:
*)