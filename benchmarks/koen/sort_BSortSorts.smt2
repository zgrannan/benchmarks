; Bitonic sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((sort2 ((x Int) (y Int)) (list Int)))
  ((ite
     (<= x y) (cons x (cons y (as nil (list Int))))
     (cons y (cons x (as nil (list Int)))))))
(define-funs-rec
  ((par (a) (evens ((x (list a))) (list a)))
   (par (a) (odds ((x (list a))) (list a))))
  ((match x
     (case nil x)
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil x)
     (case (cons y xs) (evens xs)))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((pairs ((x (list Int)) (y (list Int))) (list Int)))
  ((match x
     (case nil y)
     (case (cons z x2)
       (match y
         (case nil x)
         (case (cons x3 x4) (append (sort2 z x3) (pairs x2 x4))))))))
(define-funs-rec
  ((stitch ((x (list Int)) (y (list Int))) (list Int)))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (pairs xs y))))))
(define-funs-rec
  ((bmerge ((x (list Int)) (y (list Int))) (list Int)))
  ((match x
     (case nil x)
     (case (cons z x2)
       (match y
         (case nil x)
         (case (cons x3 x4)
           (match x2
             (case nil
               (match x4
                 (case nil (sort2 z x3))
                 (case (cons x5 x6)
                   (stitch (bmerge (evens x) (evens y)) (bmerge (odds x) (odds y))))))
             (case (cons x7 x8)
               (stitch (bmerge (evens x) (evens y))
                 (bmerge (odds x) (odds y)))))))))))
(define-funs-rec
  ((bsort ((x (list Int))) (list Int)))
  ((match x
     (case nil x)
     (case (cons y z)
       (match z
         (case nil x)
         (case (cons x2 x3)
           (bmerge (bsort (evens x)) (bsort (odds x)))))))))
(define-funs-rec
  ((and2 ((x Bool) (y Bool)) Bool)) ((ite x y false)))
(define-funs-rec
  ((ordered ((x (list Int))) Bool))
  ((match x
     (case nil true)
     (case (cons y z)
       (match z
         (case nil true)
         (case (cons y2 xs) (and2 (<= y y2) (ordered z))))))))
(assert-not (forall ((x (list Int))) (ordered (bsort x))))
(check-sat)