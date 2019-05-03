; Selection sort, using a total minimum function
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  leq
  ((x Nat) (y Nat)) Bool
  (match x
    ((zero true)
     ((succ z)
      (match y
        ((zero false)
         ((succ x2) (leq z x2))))))))
(define-fun-rec
  ordered
  ((x (list Nat))) Bool
  (match x
    ((nil true)
     ((cons y z)
      (match z
        ((nil true)
         ((cons y2 xs) (and (leq y y2) (ordered z)))))))))
(define-fun-rec
  ssort-minimum1
  ((x Nat) (y (list Nat))) Nat
  (match y
    ((nil x)
     ((cons y1 ys1)
      (ite (leq y1 x) (ssort-minimum1 y1 ys1) (ssort-minimum1 x ys1))))))
(define-fun-rec
  deleteBy
  (par (a) (((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)))
  (match z
    ((nil (_ nil a))
     ((cons y2 ys)
      (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys)))))))
(define-fun-rec
  ssort
  ((x (list Nat))) (list Nat)
  (match x
    ((nil (_ nil Nat))
     ((cons y ys)
      (let ((m (ssort-minimum1 y ys)))
        (cons m
          (ssort
            (deleteBy (lambda ((z Nat)) (lambda ((x2 Nat)) (= z x2)))
              m x))))))))
(prove (forall ((xs (list Nat))) (ordered (ssort xs))))
