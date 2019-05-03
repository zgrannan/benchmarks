; Bubble sort
(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  insert
  ((x Int) (y (list Int))) (list Int)
  (match y
    ((nil (cons x (_ nil Int)))
     ((cons z xs) (ite (<= x z) (cons x y) (cons z (insert x xs)))))))
(define-fun-rec
  isort
  ((x (list Int))) (list Int)
  (match x
    ((nil (_ nil Int))
     ((cons y xs) (insert y (isort xs))))))
(define-fun-rec
  bubble
  ((x (list Int))) (pair Bool (list Int))
  (match x
    ((nil (pair2 false (_ nil Int)))
     ((cons y z)
      (match z
        ((nil (pair2 false (cons y (_ nil Int))))
         ((cons y2 xs)
          (ite
            (<= y y2)
            (match (bubble z) (((pair2 b12 ys12) (pair2 b12 (cons y ys12)))))
            (match (bubble (cons y xs))
              (((pair2 b1 ys1) (pair2 true (cons y2 ys1)))))))))))))
(define-fun-rec
  bubsort
  ((x (list Int))) (list Int)
  (match (bubble x) (((pair2 c ys1) (ite c (bubsort ys1) x)))))
(prove (forall ((xs (list Int))) (= (bubsort xs) (isort xs))))
