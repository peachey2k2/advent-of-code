open Base
open Stdio

let file = "input.txt"

let () =
  let chan = In_channel.create file in
  let sum = ref 0 in
  let rec check_nums () =
    match In_channel.input_line chan with
    | Some line ->
        let split_line = String.split ~on:' ' line in
        let nums = Array.of_list (List.map split_line ~f:Int.of_string) in

        let is_safe = ref true in

        if nums.(0) > nums.(1) then
          for i = 0 to Array.length nums - 2 do
            if
              nums.(i) <= nums.(i+1) ||
              abs (nums.(i) - nums.(i+1)) > 3 ||
              nums.(i) = nums.(i+1) then
                is_safe := false
          done
        else
          for i = 0 to Array.length nums - 2 do
            if
              nums.(i) >= nums.(i+1) ||
              abs (nums.(i) - nums.(i+1)) > 3 ||
              nums.(i) = nums.(i+1) then
                is_safe := false
          done;
        
        sum := !sum + if !is_safe then 1 else 0;

        check_nums ()
    | None ->
        In_channel.close chan
  in
  check_nums ();
  Stdio.printf "%d\n" !sum
