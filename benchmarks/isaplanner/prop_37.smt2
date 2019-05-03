; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  ==
  ((x Nat) (y Nat)) Bool
  (match x
    ((Z
      (match y
        ((Z true)
         ((S z) false))))
     ((S x2)
      (match y
        ((Z false)
         ((S y2) (== x2 y2))))))))
(define-fun-rec
  delete
  ((x Nat) (y (list Nat))) (list Nat)
  (match y
    ((nil (_ nil Nat))
     ((cons z xs)
      (ite (== x z) (delete x xs) (cons z (delete x xs)))))))
(define-fun-rec
  elem
  ((x Nat) (y (list Nat))) Bool
  (match y
    ((nil false)
     ((cons z xs) (ite (== x z) true (elem x xs))))))
(prove
  (forall ((x Nat) (xs (list Nat))) (not (elem x (delete x xs)))))
