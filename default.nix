{ runCommand, stdenv, lib, jing, libxslt, docbook5, docbook5_xsl,
  libxml2, callPackage }:
let
  documentation-highlighter = callPackage ./documentation-highlighter {};
  manualXsltprocOptions = toString [
    "--param section.autolabel 1"
    "--param section.label.includes.component.label 1"
    "--stringparam html.stylesheet style.css"
    "--stringparam html.script './highlightjs/highlight.pack.js ./highlightjs/loader.js'"
    "--param xref.with.number.and.title 1"
    "--param toc.section.depth 3"
    "--stringparam admon.style ''"
    "--stringparam callout.graphics.extension .svg"
    "--stringparam current.docid book-docbook-rocks"
    #"--param chunk.first.sections 1"
    #"--param use.id.as.filename 1"
    "--param make.clean.html 1"
    "--param suppress.navigation 1"
    #"--stringparam generate.toc 'book chapter section'"
    "--param id.warnings 1"
  ];

in stdenv.mkDerivation {
  name = "docbook.rocks";

  src = ./.;
  buildInputs = [ jing libxslt libxml2 ];

  installPhase = ''
    jing ${docbook5}/xml/rng/docbook/docbook.rng $combined

    # Generate the HTML manual.
    dst=$out/
    mkdir -p $dst

    xmllint --xinclude --output ./combined.xml ./book.xml

    xsltproc \
      ${manualXsltprocOptions} \
      --nonet --output $dst/index.html \
      ${docbook5_xsl}/xml/xsl/docbook/xhtml/docbook.xsl \
      ./combined.xml

    sed -i -e 's#</head>#<meta name="viewport" content="width=device-width, initial-scale=1" /></head>#' $out/index.html

    mkdir -p $dst/images
    cp -r ${docbook5_xsl}/xml/xsl/docbook/images/callouts $dst/images/callouts

    cp ${./style.css} $dst/style.css
    mkdir $dst/highlightjs/
    cp ${documentation-highlighter}/highlight.pack.js \
       ${documentation-highlighter}/LICENSE \
       ${documentation-highlighter}/loader.js \
       $dst/highlightjs/
  '';
}
