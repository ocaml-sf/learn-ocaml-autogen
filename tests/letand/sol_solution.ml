let rec f x = g (x * 2)

and g x = if x > 100 then x else f x
