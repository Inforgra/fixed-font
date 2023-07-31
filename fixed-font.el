;;; fixed-font.el --- Summary

;;; Commentary:
;;
;; 글꼴은 글자폭의 형태에 따라 가변폭과 고정폭으로 구분한다.  가변폭의
;; 경우 "W"와 "I"의 가로폭(width)이 다르며, 고정폭은 같다는 차이점이
;; 있다.
;;
;; 일반적으로 가변폭이 글을 읽기에는 편안하다고 알려져 있다.  그러나
;; 개발자의 코딩용으로는 가독성이 좋지 않은 경우가 종종 발생한다.
;; "0"과 "O" 또는 "1"과 "l"의 차이를 구분이 쉽지 않은 경우도 있으며,
;; 한글과 영문을 같이 배치하는 경우 폭이 달라 읽기에 불편할 수 있다.
;;
;; |----|------|
;; |한글|테스트|
;; |ABCD|abcdef|
;; |----|------|
;;
;; 한글과 영문 글꼴을 각각 지정할 수 있다.  일반적으로 유니코드의
;; 범위로 사용할 글꼴을 지정한다.  이런 경우 같은 고정폭 글꼴이라고
;; 하더라도 각각 다른 가로폭을 가지고 있기 때문에 한글과 영문을 같이
;; 배치할 경우 읽기 좋지 않은 모양이 되는 문제가 발생한다.
;;
;; 이 패키지는 영문 글꼴의 크기에 따라 한글 글꼴의 가로폭의 비율을
;; 미리 셋팅하여, 크기만 지정하면 폭을 맞출 수 있도록 도와준다.
;;
;; use-package 를 사용하면 좀 더 쉽게 쓸 수 있다.
;;
;; (use-package fixed-font
;; :bind
;; ("C-0" . fixed-font-set-default-height)
;; ("C-+" . fiexd-font-increase)
;; ("C--" . fixed-font-decrease)
;; :config
;; (setq fixed-font-ascii-font "Monaco")
;; (setq fixed-font-hangul-font "D2Coding")
;; (setq fixed-font-default-height 100)
;; (setq fixed-font-default))
;;
;;; Code:

(defcustom fixed-font-hangul-font "D2Coding"
  "한글 글꼴을 지정한다."
  :type 'string
  :group 'fixed-font)

(defcustom fixed-font-ascii-font "Source Code Pro"
  "영문 글꼴을 지정한다."
  :type 'string
  :group 'fixed-font)

(defcustom fixed-font-default-height 100
  "글꼴의 크기를 지정한다."
  :type 'number
  :group 'fixed-font)

(defconst fixed-font-rescale-list
  '(
    ("Source Code Pro" "D2Coding"
     ((60  . 1.23)  (70  . 1.23) (80  . 1.24) (90  . 1.23) (100 . 1.23) (110 . 1.23) (120 . 1.23) (130 . 1.23) (140 . 1.23) (150 . 1.23) (160 . 1.20) (170 . 1.23)  (180 . 1.23) (190 . 1.20) (200 . 1.23) (210 . 1.23) (220 . 1.23)))
    ("Source Code Pro" "NanumGothicCoding"
     ((60  . 1.23)  (70  . 1.23) (80  . 1.24) (90  . 1.23) (100 . 1.23) (110 . 1.23) (120 . 1.23) (130 . 1.23) (140 . 1.23) (150 . 1.23) (160 . 1.20) (170 . 1.23)  (180 . 1.23) (190 . 1.20) (200 . 1.23) (210 . 1.23) (220 . 1.23)))
    ("Source Code Pro" "나눔고딕코딩"
     ((60  . 1.23)  (70  . 1.23) (80  . 1.24) (90  . 1.23) (100 . 1.23) (110 . 1.23) (120 . 1.23) (130 . 1.23) (140 . 1.23) (150 . 1.23) (160 . 1.20) (170 . 1.23)  (180 . 1.23) (190 . 1.20) (200 . 1.23) (210 . 1.23) (220 . 1.23)))
    ))

(defvar fixed-font-current-height fixed-font-default-height)

(defun fixed-font-search-font-rescale (ascii-font hangul-font height font-list)
  "영문(ASCII-FONT)과 한글(HANGUL-FONT) 글꼴의 크기(HEIGHT)에 맞는 비율을 FONT-LIST에서 찾아 반환한다."
  (cond
   ((null font-list) nil)
   ((and (string-equal ascii-font (car (car font-list)))
	 (string-equal hangul-font (car (cdr (car font-list)))))
    (fixed-font-search-rescale height (car (cdr (cdr (car font-list))))))
   (t (fixed-font-search-font-rescale ascii-font hangul-font height (cdr font-list)))))

(defun fixed-font-search-rescale (height rescale-list)
  "글꼴의 크기(HEIGHT)에 맞는 비율을 RESCALE-LIST에서 찾아 반환한다."
  (cond
   ((null rescale-list) nil)
   ((= height (car (car rescale-list))) (cdr (car rescale-list)))
   (t (fixed-font-search-rescale height (cdr rescale-list)))))

(defun fixed-font-set-height (height)
  "글꼴의 크기(HEIGHT)를 지정한다."
  (let ((rescale (fixed-font-search-font-rescale fixed-font-ascii-font fixed-font-hangul-font height fixed-font-rescale-list)))
    (message "ascii-font: %s, hangul-font: %s, height: %d, rescale %s" fixed-font-ascii-font fixed-font-hangul-font height rescale)
    (when (not (null rescale))
      (setq face-font-rescale-alist `((,fixed-font-hangul-font . ,rescale)))
      (set-face-attribute 'default nil :height height)
      (setq fixed-font-current-height height))))

(defun fixed-font-set-default ()
  "글꼴의 크기를 기본크기로 지정한다."
  (interactive)
  (set-fontset-font t 'hangul (font-spec :family fixed-font-hangul-font))
  (set-face-attribute 'default nil :family fixed-font-ascii-font)
  (fixed-font-set-height fixed-font-default-height))

(defun fixed-font-increase ()
  "글꼴의 크기를 한 단계(10) 늘린다."
  (interactive)
  (let ((new-height (+ fixed-font-current-height 10)))
    (fixed-font-set-height new-height)))

(defun fixed-font-decrease ()
  "글꼴의 크기를 한 단계(10) 줄인다."
  (interactive)
  (let ((new-height (- fixed-font-current-height 10)))
    (fixed-font-set-height new-height)))

(provide 'fixed-font)
;;; fixed-font.el ends here
