let rec make_tuple x = (float_of_int x, x)
and make_int_tuple x =
  let i = int_of_char x in (i, i)

let rec id_int x = x
and id_float x = x
