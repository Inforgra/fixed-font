;;; fixed-font.el --- 한글 고정폭 글꼴 설정 -*- lexical-binding: t; -*-

;; Copyright (C) 2023-2024 Inforgra

;; Author: Inforga <inforgax@gmail.com>
;; Keywords: font
;; Version: 0.1.0

;;; Commentary:
;;
;; https://github.com/Inforgra/fixed-font/README.md 를 참고한다.

;;; Code:

(require 'seq)

(defcustom fixed-font-hangul-font "NanumGothicCoding"
  "한글 글꼴을 지정한다."
  :type 'string
  :group 'fixed-font)

(defcustom fixed-font-ascii-font "Monospace"
  "영문 글꼴을 지정한다."
  :type 'string
  :group 'fixed-font)

(defcustom fixed-font-default-height 100
  "글꼴의 기본 크기를 지정한다."
  :type 'int
  :group 'fixed-font)

(defvar fixed-font-current-height fixed-font-default-height)

(defconst fixed-font-rescale-list ())

(add-to-list 'fixed-font-rescale-list
 '(("NanumGothicCoding" "Source Code Pro")
   ((70  . 1.10) (80  . 1.24) (90  . 1.20) (100 . 1.20) (110 . 1.23)
    (120 . 1.20) (130 . 1.20) (140 . 1.22) (150 . 1.20) (160 . 1.20)
    (170 . 1.20) (180 . 1.20) (190 . 1.20) (200 . 1.20) (210 . 1.20))))

(defun fixed-font--search (hangul ascii)
  "한글(HANGUL)과 영문(ASCII) 글꼴의 설정을 찾아 반환한다."
  (seq-find
   (lambda (val)
     (and (member hangul (car val))
	        (member ascii  (car val))))
	  fixed-font-rescale-list))

(defun fixed-font-search ()
  "한글과 영문 글꼴의 설정을 찾아 반환한다.  만약 설정에 없는 경우 기본값으로 반환한다."
  (let ((font-config (fixed-font--search fixed-font-hangul-font fixed-font-ascii-font)))
    (if (eq font-config nil)
	      (fixed-font--search "Default" "Default")
      font-config)))
    
(defun fixed-font--min-height ()
  "글꼴의 최소 크기를 반환한다."
  (let* ((font-config (fixed-font-search))
	 (rescale (car (cdr font-config))))
    (seq-min
     (seq-map (lambda (pair) (car pair)) rescale))))

(defun fixed-font--max-height ()
  "글꼴의 최대 크기를 반환한다."
  (let* ((font-config (fixed-font-search))
	 (rescale (car (cdr font-config))))
    (seq-max
     (seq-map (lambda (pair) (car pair)) rescale))))

(defun fixed-font--rescale (height)
  "영문 글꼴의 크기(HEIGHT)에 해당하는 한글 글꼴의 비율을 반환한다."
  (let ((rescales (fixed-font-search)))
    (cdr (seq-find (lambda (pair) (= (car pair) height)) (car (cdr rescales))))))

(defun fixed-font--set-height (height)
  "영문 글꼴을 지정한 크기(HEIGHT)로 설정하고, 한글 글꼴은 해당하는 비율로 지정한다."
  (let ((min-height (fixed-font--min-height))
	(max-height (fixed-font--max-height))
	(rescale (fixed-font--rescale height)))
    (when (< height min-height) (error "글꼴의 설정이 %d 보다 작을 수 없습니다" min-height))
    (when (> height max-height) (error "글꼴의 설정이 %d 보다 클 수 없습니다" max-height))
    (message "한글글꼴: %s, 영문글꼴: %s, 글꼴크기: %d, 비율: %0.2f" fixed-font-hangul-font fixed-font-ascii-font height rescale)
    (set-face-attribute 'default nil :family fixed-font-ascii-font)
    (set-fontset-font "fontset-default" 'hangul fixed-font-hangul-font nil 'prepend)
    (setq face-font-rescale-alist `((,fixed-font-hangul-font . ,rescale)))
    (set-face-attribute 'default nil :height height)))

(defun test-fixed-font-scale (ascii-font hangul-font height scale)
  "영문글꼴(ASCII-FONT)과 한글글꼴(HANGUL-FONT)에서 크기(HEIGHT)에 따른 비율(SCALE)을 테스트한다."
  (set-face-attribute 'default nil :family ascii-font)
  (set-fontset-font "fontset-default" 'hangul hangul-font nil 'prepend)
  (setq face-font-rescale-alist `((,hangul-font . ,scale)))
  (set-face-attribute 'default nil :height 60)
  (set-face-attribute 'default nil :height height))

;;;###autoload
(defun fixed-font-default ()
  "글꼴의 크기를 fixed-font-default-height로 설정한다."
  (interactive)
  (fixed-font--set-height fixed-font-default-height)
  (setq fixed-font-current-height fixed-font-default-height))


;;;###autoload
(defun fixed-font-increase ()
  "글꼴의 크기를 한단계(10) 크게 설정한다."
  (interactive)
  (let ((new-height (+ fixed-font-current-height 10)))
    (fixed-font--set-height new-height)
    (setq fixed-font-current-height new-height)))

;;;###autoload
(defun fixed-font-decrease ()
  "글꼴의 크기를 한단계(10) 작게 설정한다."
  (interactive)
  (let ((new-height (- fixed-font-current-height 10)))
    (fixed-font--set-height new-height)
    (setq fixed-font-current-height new-height)))

(provide 'fixed-font)

;;; fixed-font.el ends here
