open Lib
module SS = Set.Make(String);;

let compatEnv = "
let compat gamma gamma' at =
    (* Straightorward implementation from the theory: *)
    let fv = snd (term_getannot at) in
        VarSet.for_all (fun v -> (FunContext.find_option gamma v) = (FunContext.find_option gamma' v)) fv;;\n";;

let in_channel = open_in (Sys.argv.(1)) in
let lexbuf = Lexing.from_channel in_channel in
(try
   let result = Parser.main Lexer.token lexbuf in
   try 
     if  (compare Sys.argv.(2) "inc") == 0 then 
       (
         let _ = "" |> print_endline in
         "module FunSpecification (* : LanguageSpecification *) = struct\n" |> print_endline;
         let evaluated = result |> Grammar.loop_rules_incremental in
         let ev = result |> Grammar.loop_rules_normal in
         let rs = Grammar.Eval.remove "type_check" ev in
         let rs = Grammar.Eval.remove "compat" rs in
         let rs = Grammar.Eval.remove "check" rs in
         let rs = Grammar.Eval.remove "free_variables_cps" rs in
         let _ = rs |> Grammar.print_rules in
         let _ = "" |> print_endline in
         let _ = !(Grammar.decTerm) |> Grammar.print_term_getannot |> print_endline  in 
         let _ = !(Grammar.decTerm) |> Grammar.print_term_edit |> print_endline  in 
         let _ = "\n\tlet rec compute_hash e = Hashtbl.hash_param max_int max_int e;;" |> print_endline in
         let _ = !(Grammar.decTerm) |> Grammar.print_get_sorted_children |> print_endline  in 
         let _ = (if not (!(Grammar.isCompatEnvDec)) then compatEnv else !(Grammar.compatEnv)) |> print_endline in 
         let _ = (evaluated |> Grammar.printCheck_join) in
         let _ = (evaluated |> Grammar.printFreeVar) in
         let _ = (evaluated |> Grammar.printTr) in
         let _ = Grammar.Eval.remove "check" evaluated in 
         "end" |> print_endline
       )
     else
       result |> Grammar.loop_rules |> Grammar.print_rules
   with 
     Invalid_argument(_) -> result |> Grammar.loop_rules |> Grammar.print_rules
 with
 | Lexer.LexerException ->
   exit 0
 | Stdlib.Parsing.Parse_error ->
   Lexer.print_error "error" "Parser" lexbuf ;
   exit 0);
print_newline();
flush stdout;