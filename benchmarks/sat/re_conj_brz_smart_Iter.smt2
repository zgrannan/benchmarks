; Regular expressions using Brzozowski derivatives (see the step function)
; The plus and seq functions are smart constructors.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes () ((A (X) (Y))))
(declare-datatypes ()
  ((R (Nil)
     (Eps) (Atom (Atom_0 A)) (Plus (Plus_0 R) (Plus_1 R))
     (And (And_0 R) (And_1 R)) (Seq (Seq_0 R) (Seq_1 R))
     (Star (Star_0 R)))))
(define-fun
  seq
    ((x R) (y R)) R
    (match x
      (case default
        (match y
          (case default
            (match x
              (case default
                (match y
                  (case default (Seq x y))
                  (case Eps x)))
              (case Eps y)))
          (case Nil Nil)))
      (case Nil Nil)))
(define-fun
  plus
    ((x R) (y R)) R
    (match x
      (case default
        (match y
          (case default (Plus x y))
          (case Nil x)))
      (case Nil y)))
(define-fun-rec
  iter
    ((x Nat) (y R)) R
    (match x
      (case Z Eps)
      (case (S n) (seq y (iter n y)))))
(define-fun-rec
  equal
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z
        (match y
          (case Z true)
          (case (S z) false)))
      (case (S x2)
        (match y
          (case Z false)
          (case (S y2) (equal x2 y2))))))
(define-fun unequal ((x Nat) (y Nat)) Bool (not (equal x y)))
(define-fun
  eqA
    ((x A) (y A)) Bool
    (match x
      (case X
        (match y
          (case X true)
          (case Y false)))
      (case Y
        (match y
          (case X false)
          (case Y true)))))
(define-fun-rec
  eps
    ((x R)) Bool
    (match x
      (case default false)
      (case Eps true)
      (case (Plus q q2) (or (eps q) (eps q2)))
      (case (And p2 q3) (and (eps p2) (eps q3)))
      (case (Seq p3 q4) (and (eps p3) (eps q4)))
      (case (Star y) true)))
(define-fun epsR ((x R)) R (ite (eps x) Eps Nil))
(define-fun
  conj
    ((x R) (y R)) R
    (match x
      (case default
        (match y
          (case default (And x y))
          (case Nil Nil)))
      (case Nil Nil)))
(define-fun-rec
  step
    ((x R) (y A)) R
    (match x
      (case default Nil)
      (case (Atom a) (ite (eqA a y) Eps Nil))
      (case (Plus q q2) (plus (step q y) (step q2 y)))
      (case (And p2 q3) (conj (step p2 y) (step q3 y)))
      (case (Seq p3 q4)
        (plus (seq (step p3 y) q4) (seq (epsR p3) (step q4 y))))
      (case (Star p4) (seq (step p4 y) x))))
(define-fun-rec
  recognise
    ((x R) (y (list A))) Bool
    (match y
      (case nil (eps x))
      (case (cons z xs) (recognise (step x z) xs))))
(assert-not
  (forall ((i Nat) (j Nat) (q R) (s (list A)))
    (=> (unequal i j)
      (=> (distinct (eps q) false)
        (not (recognise (conj (iter i q) (iter j q)) s))))))
(check-sat)