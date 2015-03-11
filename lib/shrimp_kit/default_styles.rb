module ShrimpKit

  BULLETS = %w{– • ◦ ▸ ✦ □}

  ALLOWED_TAGS = %w{
    body _text_
    h1 h2 h3 h4
    p div br
    a
    i em b strong u
    ul ol li
    table tbody thead tfoot tr td th
    img
  }

  DEFAULT_STYLES = <<-CSS
    * {
      display: inline;
      font-size: 11pt;
      margin-top: 0;
      margin-bottom: 0;
      margin-left: 0;
      color: #000000
    }
    body {
      display: block;
    }
    h1 {
      display: block;
      font-size: 16pt;
      font-weight: bold;
      margin-top: 6mm;
      margin-bottom: 3mm
    }
    h2 {
      display: block;
      font-size: 14pt;
      font-weight: bold;
      margin-top: 4mm;
      margin-bottom: 1mm
    }
    h3 {
      display: block;
      font-size: 12pt;
      font-weight: bold;
      margin-top: 2mm;
      margin-bottom: 1mm
    }
    h4 {
      display: block;
      font-size: 11pt;
      font-weight: bold;
      margin-top: 2mm;
      margin-bottom: 1mm
    }
    p {
      display: block;
      margin-bottom: 2mm;
      text-align: justify;
    }
    div {
      display: block;
      margin-bottom: 2mm;
      margin-left: 1cm
    }
    br {
      display: inline
    }
    i {
      display: inline;
      font-style: italic
    }
    em {
      display: inline;
      font-style: italic
    }
    b {
      display: inline;
      font-weight: bold
    }
    strong {
      display: inline;
      font-weight: bold
    }
    u {
      display: inline;
      font-weight: underline;
    }
    a {
      display: inline;
      font-weight: underline
    }
    ul {
      display: block;
      margin-top: 1mm;
      margin-bottom: 1mm
    }
    ol {
      display: block;
      margin-top: 1mm;
      margin-bottom: 1mm
    }
    li {
      display: block;
      margin-left: 20mm    }
    img {
      display: block
    }
    table {}
    tbody {}
    thead {}
    tfoot {}
    tr {}
    td {}
    th {}
    _text_ {
      display: inline
    }
  CSS
end
