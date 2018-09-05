{ runCommand, stdenv, lib, jing, libxslt, docbook5, docbook5_xsl, libxml2 }:
let
  manualXsltprocOptions = toString [
    "--param section.autolabel 1"
    "--param section.label.includes.component.label 1"
    "--stringparam html.stylesheet style.css"
    "--param xref.with.number.and.title 1"
    "--param toc.section.depth 3"
    "--stringparam admon.style ''"
    "--stringparam callout.graphics.extension .svg"
    "--stringparam current.docid book-docbook-rocks"
    #"--param chunk.section.depth 0"
    #"--param chunk.first.sections 1"
    #"--param use.id.as.filename 1"
    "--param make.clean.html 1"
    "--param suppress.navigation 1"
    "--stringparam generate.toc 'book'"
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

    mkdir -p $dst/images
    cp -r ${docbook5_xsl}/xml/xsl/docbook/images/callouts $dst/images/callouts

    cp ${./style.css} $dst/style.css
  '';
}
