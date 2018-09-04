{ stdenv }:
stdenv.mkDerivation {
  name = "docbook.rocks";
  src = ./.;
  installPhase = ''
    cp -r $src $out
  '';
}
