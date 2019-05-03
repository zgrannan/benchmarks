; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun
  one
  () Nat (S Z))
(define-fun-rec
  +2
  ((x Nat) (y Nat)) Nat
  (match x
    ((Z y)
     ((S z) (S (+2 z y))))))
(define-fun-rec
  *2
  ((x Nat) (y Nat)) Nat
  (match x
    ((Z Z)
     ((S z) (+2 y (*2 z y))))))
(define-fun-rec
  fac
  ((x Nat)) Nat
  (match x
    ((Z (S Z))
     ((S y) (*2 x (fac y))))))
(define-fun-rec
  qfac
  ((x Nat) (y Nat)) Nat
  (match x
    ((Z y)
     ((S z) (qfac z (*2 x y))))))
(prove (forall ((x Nat)) (= (fac x) (qfac x one))))
