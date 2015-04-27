; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (t) (x ((q (=> t bool)) (y (list t))) (list t))))
  ((match y
     (case nil y)
     (case (cons z x2) (ite (@ q z) (cons z (x q x2)) (x q x2))))))
(define-funs-rec
  ((count ((y int) (z (list int))) Nat))
  ((match z
     (case nil Z)
     (case (cons y2 xs) (ite (= y y2) (S (count y xs)) (count y xs))))))
(define-funs-rec
  ((par (a) (append ((y (list a)) (z (list a))) (list a))))
  ((match y
     (case nil z)
     (case (cons x2 xs) (cons x2 (append xs z))))))
(define-funs-rec
  ((qsort ((y (list int))) (list int)))
  ((match y
     (case nil y)
     (case (cons z xs)
       (append
       (append (qsort (x (lambda ((x2 int)) (<= x2 z)) xs))
         (cons z (as nil (list int))))
         (qsort (x (lambda ((x3 int)) (> x3 z)) xs)))))))
(assert-not
  (forall ((y int) (z (list int)))
    (= (count y (qsort z)) (count y z))))
(check-sat)
