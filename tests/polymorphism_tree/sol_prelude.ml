type 'a tree =
  | Node of 'a tree * 'a tree
  | Leaf of 'a
