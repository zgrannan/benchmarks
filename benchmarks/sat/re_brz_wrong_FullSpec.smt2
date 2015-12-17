; Regular expressions using Brzozowski derivatives (see the step function)
; This version does not use smart constructors.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((A (X) (Y))))
(declare-datatypes ()
  ((R (Nil)
     (Eps) (Atom (Atom_0 A)) (Plus (Plus_0 R) (Plus_1 R))
     (Seq (Seq_0 R) (Seq_1 R)) (Star (Star_0 R)))))
(define-fun-rec
  (par (a)
    (splits2
       ((x a) (y (list (Pair (list a) (list a)))))
       (list (Pair (list a) (list a)))
       (match y
         (case nil (as nil (list (Pair (list a) (list a)))))
         (case (cons z x2)
           (match z
             (case (Pair2 bs cs)
               (cons (Pair2 (cons x bs) cs) (splits2 x x2)))))))))
(define-fun-rec
  (par (a)
    (splits
       ((x (list a))) (list (Pair (list a) (list a)))
       (match x
         (case nil
           (cons (Pair2 (as nil (list a)) (as nil (list a)))
             (as nil (list (Pair (list a) (list a))))))
         (case (cons y xs)
           (cons (Pair2 (as nil (list a)) x) (splits2 y (splits xs))))))))
(define-fun-rec
  or2
    ((x (list Bool))) Bool
    (match x
      (case nil false)
      (case (cons y xs) (or y (or2 xs)))))
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
      (case (Plus p q) (or (eps p) (eps q)))
      (case (Seq r q2) (and (eps r) (eps q2)))
      (case (Star y) true)))
(define-fun epsR ((x R)) R (ite (eps x) Eps Nil))
(define-fun-rec
  step
    ((x R) (y A)) R
    (match x
      (case default Nil)
      (case (Atom a) (ite (eqA a y) Eps Nil))
      (case (Plus p q) (Plus (step p y) (step q y)))
      (case (Seq r q2)
        (Plus (Seq (step r y) q2) (Seq (epsR r) (step q2 y))))
      (case (Star p2) (Seq (step p2 y) x))))
(define-funs-rec
  ((reck ((x R) (y (list A))) Bool)
   (reck2
      ((p R) (q R) (x (list (Pair (list A) (list A))))) (list Bool)))
  ((match x
     (case Nil false)
     (case Eps
       (match y
         (case nil true)
         (case (cons z x2) false)))
     (case (Atom b)
       (match y
         (case nil false)
         (case (cons c x3)
           (match x3
             (case nil (eqA b c))
             (case (cons x4 x5) false)))))
     (case (Plus p q) (or (reck p y) (reck q y)))
     (case (Seq r q2) (or2 (reck2 r q2 (splits y))))
     (case (Star p2)
       (match y
         (case nil true)
         (case (cons x6 x7) (and (not (eps p2)) (reck (Seq p2 x) y))))))
   (match x
     (case nil (as nil (list Bool)))
     (case (cons y z)
       (match y
         (case (Pair2 l r)
           (cons (and (reck p l) (reck q r)) (reck2 p q z))))))))
(define-fun-rec
  recognise
    ((x R) (y (list A))) Bool
    (match y
      (case nil (eps x))
      (case (cons z xs) (recognise (step x z) xs))))
(assert-not
  (forall ((p R) (s (list A))) (= (recognise p s) (reck p s))))
(check-sat)