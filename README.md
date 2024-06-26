

# Fixed Font

글꼴(font)은 세리프(serif)의 유뮤, 글자의 폭, 구현 방식등에 따라 다양하게 분류 할 수 있다. 이 중에 글자에 따라 폭에 따라 변화할 때 가변폭(variable width) 또는 고정폭(fixed width) 으로  구분한다. 가변폭의 경우 글자에 따라 자연스럽게 너비가 변화한다. \`W\` 또는 \`M\` 고 같이 넓은 글자와 \`I\` 와 같이 좁은 글자가 차지하는 폭이 달라진다. 이와 반대로 고정폭은 모든 글자가 일정한 폭을 가진다.

일반적으로 책이나 게시물을 읽기에는 가변폭 글꼴을 사용하는 것이 좋다. 그러나 코딩을 할 때에는 띄어쓰기나 글자의 갯수를 세기 쉬워야하며, 헷갈리는 글자들의 사이에서 판독성이 좋아야 함으로 고정폭 글꼴을 사용한다.

고정폭 한글 글꼴은 \`나눔고딕코딩\`, \`D2 Coding\` 정도가 있으며, 모두 코딩용으로 사용하기에 적합하다. 그러나 많은 개발자들은 \`Consolas\`, \`Source Code Pro\`, \`Fira Code\` 등 영문 글꼴을 좀 더 선호하는 편이다.

이 패키지는 \`Emacs\` 에서 한글에는 한글 글꼴로 이외에는 영문 글꼴로 설정하여, 사용자가 선호하는 글꼴을 조합하여 사용할 수 있도록 한다. 좀 더 쉽게 글꼴의 크기를 조정할 수 있는 단축키를 제공한다.

-   [Fixed Font 설치하기](#org1d3015e)
-   [글꼴 설정하기](#org13ac781)
-   [\`use-package\` 를 사용하여 설정하기](#orga251f6c)
-   [테스트한 글꼴](#org8556ed8)


<a id="org1d3015e"></a>

## Fixed Font 설치하기

이 Github 에서 복제하거나 \`package-vc-install\` 을 사용하여 설치한다.

```lisp
(package-installed-p `fixed-font
                     (package-vc-install "https://github.com/Inforgra/fixed-font"))
```
<a id="org13ac781"></a>

## 글꼴 설정하기

한글 글꼴은 \`fixed-font-hangul-font\` 변수에 지정한다.

```lisp
(setq fixed-font-hangul-font "NanumGothicCoding")
```

영문 글꼴은 \`fixed-font-ascii-font\` 변수에 지정한다.

```lisp
(setq fixed-font-ascii-font "Source Code Pro")
```

글꼴의 크기는 \`fixed-font-default-height\` 변수에 지정한다.

```lisp
(setq fixed-font-default-height 100)
```

같은 고정폭 형태의 글꼴이라 하더라도 모두 같은 폭을 가지지 않는다. 또한 글꼴의 크기에 따라 비율이 달라질 수 있다. \`fixed-font-rescale-list\` 에 설정을 추가하여, 글꼴간의 비율을 변경할 수 있다.

```lisp
(add-to-list `fixed-font-rescale-list
  '(("NanumGothicCoding" "Source Code Pro")
    (70  . 1.20) (80  . 1.30) (90  . 1.25) (100 . 1.20) (110 . 1.20) (120 . 1.20)))
```

<a id="orga251f6c"></a>

## \`use-package\` 를 사용하여 설정하기

```lisp
(use-package fixed-font
  :bind
  ("C-0" . fixed-font-default)
  ("C-+" . fixed-font-increase)
  ("C--" . fixed-font-decrease)
  :custom
  (fixed-font-hangul-font "NanumGothicCoding")
  (fixed-font-ascii-font "Source Code Pro")
  (fixed-font-default-height 160))
```

<a id="org8556ed8"></a>

## 테스트한 글꼴

\`나눔고딕코딩\` 글꼴과 함께 테스트한 고정폭 영문 글꼴은 다음과 같다.

-   [Anonymouse Pro](https://www.marksimonson.com/fonts/view/anonymous-pro)
-   [B612 Mono](https://b612-font.com/)
-   [Fira Mono](http://mozilla.github.io/Fira/)
-   [Inconsolata](https://github.com/googlefonts/Inconsolata)
-   [IBM Plex Mono](https://www.ibm.com/plex/)
-   [JetBrains Mono](https://www.jetbrains.com/lp/mono/)
-   [Kode Mono](https://kodemono.com/)
-   [PT Mono](https://www.paratype.com/fonts/pt/pt-mono)
-   [Red Hat Mono](https://www.redhat.com/en/about/brand/standards/typography)
-   [Source Code Pro](https://adobe-fonts.github.io/source-code-pro/)
-   [Space Mono](https://www.colophon-foundry.org/custom-projects/space-mono)
-   [Ubuntu Mono](https://design.ubuntu.com/font)
-   [VT323](https://fonts.google.com/specimen/VT323)

