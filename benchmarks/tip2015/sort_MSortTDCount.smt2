; Top-down merge sort
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  take
  (par (a) (((x Int) (y (list a))) (list a)))
  (ite
    (<= x 0) (_ nil a)
    (match y
      ((nil (_ nil a))
       ((cons z xs) (cons z (take (- x 1) xs)))))))
(define-fun-rec
  lmerge
  ((x (list Int)) (y (list Int))) (list Int)
  (match x
    ((nil y)
     ((cons z x2)
      (match y
        ((nil x)
         ((cons x3 x4)
          (ite
            (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))))
(define-fun-rec
  length
  (par (a) (((x (list a))) Int))
  (match x
    ((nil 0)
     ((cons y l) (+ 1 (length l))))))
(define-fun-rec
  drop
  (par (a) (((x Int) (y (list a))) (list a)))
  (ite
    (<= x 0) y
    (match y
      ((nil (_ nil a))
       ((cons z xs1) (drop (- x 1) xs1))))))
(define-fun-rec
  msorttd
  ((x (list Int))) (list Int)
  (match x
    ((nil (_ nil Int))
     ((cons y z)
      (match z
        ((nil (cons y (_ nil Int)))
         ((cons x2 x3)
          (let ((k (div (length x) 2)))
            (lmerge (msorttd (take k x)) (msorttd (drop k x)))))))))))
(define-fun-rec
  count
  (par (a) (((x a) (y (list a))) Int))
  (match y
    ((nil 0)
     ((cons z ys) (ite (= x z) (+ 1 (count x ys)) (count x ys))))))
(prove
  (forall ((x Int) (xs (list Int)))
    (= (count x (msorttd xs)) (count x xs))))
