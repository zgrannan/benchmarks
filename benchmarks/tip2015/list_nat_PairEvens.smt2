(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  plus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero y)
     ((succ z) (succ (plus z y))))))
(define-fun-rec
  pairs
  (par (b) (((x (list b))) (list (pair b b))))
  (match x
    ((nil (_ nil (pair b b)))
     ((cons y z)
      (match z
        ((nil (_ nil (pair b b)))
         ((cons y2 xs) (cons (pair2 y y2) (pairs xs)))))))))
(define-fun-rec
  map
  (par (a b) (((f (=> a b)) (x (list a))) (list b)))
  (match x
    ((nil (_ nil b))
     ((cons y xs) (cons (@ f y) (map f xs))))))
(define-fun-rec
  length
  (par (a) (((x (list a))) Nat))
  (match x
    ((nil zero)
     ((cons y l) (plus (succ zero) (length l))))))
(define-funs-rec
  ((evens
    (par (a) (((x (list a))) (list a))))
   (odds
    (par (a) (((x (list a))) (list a)))))
  ((match x
     ((nil (_ nil a))
      ((cons y xs) (cons y (odds xs)))))
   (match x
     ((nil (_ nil a))
      ((cons y xs) (evens xs))))))
(define-fun-rec
  even
  ((x Nat)) Bool
  (match x
    ((zero true)
     ((succ y) (not (even y))))))
(prove
  (par (a)
    (forall ((xs (list a)))
      (=> (= (ite (even (length xs)) zero (succ zero)) zero)
        (=
          (map (lambda ((x (pair a a))) (match x (((pair2 y z) y))))
            (pairs xs))
          (evens xs))))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
