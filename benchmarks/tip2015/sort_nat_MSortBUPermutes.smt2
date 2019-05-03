; Bottom-up merge sort
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  map
  (par (a b) (((f (=> a b)) (x (list a))) (list b)))
  (match x
    ((nil (_ nil b))
     ((cons y xs) (cons (@ f y) (map f xs))))))
(define-fun-rec
  leq
  ((x Nat) (y Nat)) Bool
  (match x
    ((zero true)
     ((succ z)
      (match y
        ((zero false)
         ((succ x2) (leq z x2))))))))
(define-fun-rec
  lmerge
  ((x (list Nat)) (y (list Nat))) (list Nat)
  (match x
    ((nil y)
     ((cons z x2)
      (match y
        ((nil x)
         ((cons x3 x4)
          (ite
            (leq z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))))
(define-fun-rec
  pairwise
  ((x (list (list Nat)))) (list (list Nat))
  (match x
    ((nil (_ nil (list Nat)))
     ((cons xs y)
      (match y
        ((nil (cons xs (_ nil (list Nat))))
         ((cons ys xss) (cons (lmerge xs ys) (pairwise xss)))))))))
(define-fun-rec
  mergingbu
  ((x (list (list Nat)))) (list Nat)
  (match x
    ((nil (_ nil Nat))
     ((cons xs y)
      (match y
        ((nil xs)
         ((cons z x2) (mergingbu (pairwise x)))))))))
(define-fun
  msortbu
  ((x (list Nat))) (list Nat)
  (mergingbu (map (lambda ((y Nat)) (cons y (_ nil Nat))) x)))
(define-fun-rec
  elem
  (par (a) (((x a) (y (list a))) Bool))
  (match y
    ((nil false)
     ((cons z xs) (or (= z x) (elem x xs))))))
(define-fun-rec
  deleteBy
  (par (a) (((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)))
  (match z
    ((nil (_ nil a))
     ((cons y2 ys)
      (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys)))))))
(define-fun-rec
  isPermutation
  (par (a) (((x (list a)) (y (list a))) Bool))
  (match x
    ((nil
      (match y
        ((nil true)
         ((cons z x2) false))))
     ((cons x3 xs)
      (and (elem x3 y)
        (isPermutation xs
          (deleteBy (lambda ((x4 a)) (lambda ((x5 a)) (= x4 x5))) x3 y)))))))
(prove (forall ((xs (list Nat))) (isPermutation (msortbu xs) xs)))
