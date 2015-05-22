; Heap sort (using skew heaps)
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Heap (Node (Node_0 (Heap a)) (Node_1 a) (Node_2 (Heap a)))
     (Nil))))
(define-funs-rec
  ((toHeap2 ((x (list Int))) (list (Heap Int))))
  ((match x
     (case nil (as nil (list (Heap Int))))
     (case (cons y z)
       (cons (Node (as Nil (Heap Int)) y (as Nil (Heap Int)))
         (toHeap2 z))))))
(define-funs-rec ((or2 ((x Bool) (y Bool)) Bool)) ((ite x true y)))
(define-funs-rec
  ((par (t) (null ((x (list t))) Bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((hmerge ((x (Heap Int)) (y (Heap Int))) (Heap Int)))
  ((match x
     (case (Node z x2 x3)
       (match y
         (case (Node x4 x5 x6)
           (ite
             (<= x2 x5) (Node (hmerge x3 y) x2 z) (Node (hmerge x x6) x5 x4)))
         (case Nil x)))
     (case Nil y))))
(define-funs-rec
  ((hpairwise ((x (list (Heap Int)))) (list (Heap Int))))
  ((match x
     (case nil x)
     (case (cons p y)
       (match y
         (case nil x)
         (case (cons q qs) (cons (hmerge p q) (hpairwise qs))))))))
(define-funs-rec
  ((hmerging ((x (list (Heap Int)))) (Heap Int)))
  ((match x
     (case nil (as Nil (Heap Int)))
     (case (cons p y)
       (match y
         (case nil p)
         (case (cons z x2) (hmerging (hpairwise x))))))))
(define-funs-rec
  ((toHeap ((x (list Int))) (Heap Int))) ((hmerging (toHeap2 x))))
(define-funs-rec
  ((toList ((x (Heap Int))) (list Int)))
  ((match x
     (case (Node p y q) (cons y (toList (hmerge p q))))
     (case Nil (as nil (list Int))))))
(define-funs-rec
  ((hsort ((x (list Int))) (list Int))) ((toList (toHeap x))))
(define-funs-rec
  ((elem ((x Int) (y (list Int))) Bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or2 (= x z) (elem x ys))))))
(define-funs-rec
  ((delete ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil y)
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((and2 ((x Bool) (y Bool)) Bool)) ((ite x y false)))
(define-funs-rec
  ((isPermutation ((x (list Int)) (y (list Int))) Bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and2 (elem z y) (isPermutation xs (delete z y)))))))
(assert-not (forall ((x (list Int))) (isPermutation (hsort x) x)))
(check-sat)