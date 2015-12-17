(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (Just_0 a)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus n y)))))
(define-fun-rec
  petersen3
    ((x Nat) (y (list Nat))) (list (Pair Nat Nat))
    (match y
      (case nil (as nil (list (Pair Nat Nat))))
      (case (cons z x2) (cons (Pair2 z (plus x z)) (petersen3 x x2)))))
(define-fun-rec
  petersen2
    ((x Nat) (y (list (Pair Nat Nat)))) (list (list (Pair Nat Nat)))
    (match y
      (case nil (as nil (list (list (Pair Nat Nat)))))
      (case (cons z x2)
        (match z
          (case (Pair2 u v)
            (cons
              (cons z
                (cons (Pair2 (plus x u) (plus x v))
                  (as nil (list (Pair Nat Nat)))))
              (petersen2 x x2)))))))
(define-fun-rec
  petersen
    ((x (list Nat))) (list (Pair Nat Nat))
    (match x
      (case nil (as nil (list (Pair Nat Nat))))
      (case (cons y z) (cons (Pair2 y (S y)) (petersen z)))))
(define-fun-rec
  lt
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z false)
      (case (S z)
        (match x
          (case Z true)
          (case (S n) (lt n z))))))
(define-fun-rec
  target_colour_petersen_21
    ((x (list Nat))) (list Bool)
    (match x
      (case nil (as nil (list Bool)))
      (case (cons y z)
        (cons (lt y (S (S (S Z)))) (target_colour_petersen_21 z)))))
(define-fun-rec
  (par (a)
    (index
       ((x (list a)) (y Nat)) (Maybe a)
       (match x
         (case nil (as Nothing (Maybe a)))
         (case (cons z xs)
           (match y
             (case Z (Just z))
             (case (S n) (index xs n))))))))
(define-fun-rec
  ge
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z true)
      (case (S z)
        (match x
          (case Z false)
          (case (S x2) (ge x2 z))))))
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
(define-fun-rec
  enumFromTo
    ((x Nat) (y Nat)) (list Nat)
    (ite (ge x y) (as nil (list Nat)) (cons x (enumFromTo (S x) y))))
(define-fun-rec
  colouring2
    ((a (list Nat)) (x (list (Pair Nat Nat)))) (list Bool)
    (match x
      (case nil (as nil (list Bool)))
      (case (cons y z)
        (match y
          (case (Pair2 u v)
            (match (index a u)
              (case Nothing (cons false (colouring2 a z)))
              (case (Just c1)
                (match (index a v)
                  (case Nothing (cons false (colouring2 a z)))
                  (case (Just c2) (cons (unequal c1 c2) (colouring2 a z)))))))))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  (par (a)
    (concat2
       ((x (list (list a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons xs xss) (append xs (concat2 xss)))))))
(define-fun-rec
  and2
    ((x (list Bool))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and y (and2 xs)))))
(define-fun
  colouring
    ((x (list (Pair Nat Nat))) (y (list Nat))) Bool
    (and2 (colouring2 y x)))
(assert-not
  (forall ((a (list Nat)))
    (or
      (not
        (colouring
          (let
            ((pn
                (S
                  (S
                    (S
                      (S
                        (S
                          (S
                            (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))
            (append
              (concat2
                (petersen2 (S pn)
                  (cons (Pair2 pn Z) (petersen (enumFromTo Z pn)))))
              (petersen3 (S pn) (enumFromTo Z (S pn)))))
          a))
      (not (and2 (target_colour_petersen_21 a))))))
(check-sat)
