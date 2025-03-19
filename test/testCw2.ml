open QCheck

(* Question 1 *)

module Q1 = Cw2.Question1

let _ = print_string ("================================================================================\n"
                    ^ "=== Testing Question 1 =========================================================\n")

let testValid1 =
    Test.make ~count:1
              ~name:"isValidSeq Test 1"
              unit (fun _ -> Q1.isValidSeq (3,4) [(4,5);(6,5)] [NE;SE] = true)

let testValid2 =
    Test.make ~count:1
              ~name:"isValidSeq Test 2"
              unit (fun _ -> Q1.isValidSeq (3,4) [(4,5);(6,5)] [NE] = false)

let testValid3 =
    Test.make ~count:1
              ~name:"isValidSeq Test 3"
              unit (fun _ -> Q1.isValidSeq (3,4) [(4,5);(6,5)] [NE;SE;SE] = false)

let testValid4 =
    Test.make ~count:1
              ~name:"isValidSeq Test 4"
              unit (fun _ -> Q1.isValidSeq (3,4) [(4,5);(6,5)] [] = false)

let testValid5 =
    Test.make ~count:1
              ~name:"isValidSeq Test 5"
              unit (fun _ -> Q1.isValidSeq (3,4) [(5,6)] [] = true)

let testValid6 =
    Test.make ~count:1
              ~name:"isValidSeq Test 6"
              unit (fun _ -> Q1.isValidSeq (3,4) [(4,5);(5,6)] [] = true)

let testValid7 =
    Test.make ~count:1
              ~name:"isValidSeq Test 7"
              unit (fun _ -> Q1.isValidSeq (3,4) [(4,5);(4,7);(6,5);(5,2)] [NE;SE] = true)

let testValid8 =
    Test.make ~count:1
              ~name:"isValidSeq Test 8"
              unit (fun _ -> Q1.isValidSeq (3,4) [(4,5);(4,7);(6,5);(5,2)] [NE;NW] = true)

let testValid9 =
    Test.make ~count:1
              ~name:"isValidSeq Test 9"
              unit (fun _ -> Q1.isValidSeq (3,4) [(4,5);(4,7);(6,5);(5,2)] [NE;SE;SW] = false)

let testAllMoves1 =
    Test.make ~count:1
              ~name:"allMoves: Figure 1"
              unit (fun _ -> Q1.allMoves (3,4) [(4,5);(6,5)] = [[NE;SE]])


let testAllMoves2 =
    Test.make ~count:1
              ~name:"allMoves: Figure 2"
              unit (fun _ -> Q1.allMoves (3,4) [(5,6)] = [])


let testAllMoves3 =
    Test.make ~count:1
              ~name:"allMoves: Figure 3"
              unit (fun _ -> Q1.allMoves (3,4) [(4,5);(5,6)] = [])


let testAllMoves4 =
    Test.make ~count:1
              ~name:"allMoves: Figure 4"
              unit (fun _ -> Q1.allMoves (3,4) [(4,5);(4,7);(6,5);(5,2)] = [[NE;SE];[NE;NW]]
                          || Q1.allMoves (3,4) [(4,5);(4,7);(6,5);(5,2)] = [[NE;NW];[NE;SE]])

let n1 = QCheck_runner.run_tests ~out:stdout
           [ testValid1
           ; testValid2
           ; testValid3
           ; testValid4
           ; testValid5
           ; testValid6
           ; testValid7
           ; testValid8
           ; testValid9
           ; testAllMoves1
           ; testAllMoves2
           ; testAllMoves3
           ; testAllMoves4
           ]

(* Question 2 *)

module Q2 = Cw2.Question2

let _ = print_string ("================================================================================\n"
                    ^ "=== Testing Question 2 =========================================================\n")

let n2 = QCheck_runner.run_tests ~out:stdout
           [ (* add QCheck tests here *)
           ]

(* error code is the number of failed/errored tests *)
let _ = print_int (n1 + n2); exit n1 + n2
