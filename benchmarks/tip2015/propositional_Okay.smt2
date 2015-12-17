; Propositional solver
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes ()
  ((Form (& (&_0 Form) (&_1 Form))
     (Not (Not_0 Form)) (Var (Var_0 Int)))))
(define-fun-rec
  zelem
    ((x Int) (y (list Int))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (= x z) (zelem x ys)))))
(define-fun-rec
  or2
    ((x (list Bool))) Bool
    (match x
      (case nil false)
      (case (cons y xs) (or y (or2 xs)))))
(define-fun-rec
  models4
    ((x Int) (y (list (Pair Int Bool)))) (list Bool)
    (match y
      (case nil (as nil (list Bool)))
      (case (cons z x2)
        (match z
          (case (Pair2 y2 x3)
            (ite x3 (models4 x x2) (cons (= x y2) (models4 x x2))))))))
(define-fun-rec
  models3
    ((x Int) (y (list (Pair Int Bool)))) (list Bool)
    (match y
      (case nil (as nil (list Bool)))
      (case (cons z x2)
        (match z
          (case (Pair2 y2 x3)
            (ite x3 (cons (= x y2) (models3 x x2)) (models3 x x2)))))))
(define-fun-rec
  (par (a b)
    (map2
       ((x (=> a b)) (y (list a))) (list b)
       (match y
         (case nil (as nil (list b)))
         (case (cons z xs) (cons (@ x z) (map2 x xs)))))))
(define-fun
  (par (a b)
    (fst ((x (Pair a b))) a (match x (case (Pair2 y z) y)))))
(define-fun-rec
  okay
    ((x (list (Pair Int Bool)))) Bool
    (match x
      (case nil true)
      (case (cons y m)
        (match y
          (case (Pair2 z c)
            (and
              (not (zelem z (map2 (lambda ((x2 (Pair Int Bool))) (fst x2)) m)))
              (okay m)))))))
(define-fun-rec
  (par (a)
    (filter
       ((x (=> a Bool)) (y (list a))) (list a)
       (match y
         (case nil (as nil (list a)))
         (case (cons z xs)
           (ite (@ x z) (cons z (filter x xs)) (filter x xs)))))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-funs-rec
  ((models
      ((x Form) (y (list (Pair Int Bool))))
      (list (list (Pair Int Bool))))
   (models2
      ((q Form) (x (list (list (Pair Int Bool)))))
      (list (list (Pair Int Bool))))
   (models5
      ((q Form) (x (list (list (Pair Int Bool))))
       (y (list (list (Pair Int Bool)))))
      (list (list (Pair Int Bool)))))
  ((match x
     (case (& p q) (models2 q (models p y)))
     (case (Not z)
       (match z
         (case (& r q2)
           (append (models (Not r) y) (models (& r (Not q2)) y)))
         (case (Not p2) (models p2 y))
         (case (Var x2)
           (ite
             (not (or2 (models3 x2 y)))
             (cons
               (cons (Pair2 x2 false)
                 (filter (lambda ((x3 (Pair Int Bool))) (distinct x2 (fst x3))) y))
               (as nil (list (list (Pair Int Bool)))))
             (as nil (list (list (Pair Int Bool))))))))
     (case (Var x4)
       (ite
         (not (or2 (models4 x4 y)))
         (cons
           (cons (Pair2 x4 true)
             (filter (lambda ((x5 (Pair Int Bool))) (distinct x4 (fst x5))) y))
           (as nil (list (list (Pair Int Bool)))))
         (as nil (list (list (Pair Int Bool)))))))
   (match x
     (case nil (as nil (list (list (Pair Int Bool)))))
     (case (cons y z) (models5 q z (models q y))))
   (match y
     (case nil (models2 q x))
     (case (cons z x2) (cons z (models5 q x x2))))))
(define-fun-rec
  (par (a)
    (all
       ((x (=> a Bool)) (y (list a))) Bool
       (match y
         (case nil true)
         (case (cons z xs) (and (@ x z) (all x xs)))))))
(assert-not
  (forall ((p Form))
    (all (lambda ((x (list (Pair Int Bool)))) (okay x))
      (models p (as nil (list (Pair Int Bool)))))))
(check-sat)
