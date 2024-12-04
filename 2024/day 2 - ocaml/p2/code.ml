open Base
open Stdio

let file = "../input.txt"

let () =
  let chan = In_channel.create file in
  let sum = ref 0 in
  let rec check_nums () =
    match In_channel.input_line chan with
    | Some line ->
        let split_line = String.split ~on:' ' line in
        let nums_full = Array.of_list (List.map split_line ~f:Int.of_string) in

        let is_safe_at_any = ref false in
        
        for j = 0 to Array.length nums_full - 1 do
          let is_safe = ref true in
          let nums = Array.append
            (Array.sub nums_full ~pos:0 ~len:j)
            (Array.sub nums_full ~pos:(j+1) ~len:(Array.length nums_full - j - 1)) in

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
          if !is_safe then is_safe_at_any := true;
        done;
        
        sum := !sum + if !is_safe_at_any then 1 else 0;

        check_nums ()
    | None ->
        In_channel.close chan
  in
  check_nums ();
  Stdio.printf "%d\n" !sum
