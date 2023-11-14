{
  cmake,
  fetchFromGitHub,
  lib,
  pkg-config,
  stdenv,
  enableSse ? false,
}:
stdenv.mkDerivation rec {
  pname = "basis-universal";
  version = "1.16.4";

  src = fetchFromGitHub {
    owner = "BinomialLLC";
    repo = "basis_universal";
    rev = version;
    hash = "sha256-zBRAXgG5Fi6+5uPQCI/RCGatY6O4ELuYBoKrPNn4K+8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags =
    if enableSse
    then [
      "-D SSE=TRUE"
    ]
    else [];

  meta = with lib; {
    description = "Basis Universal GPU Texture Codec";
    longDescription = ''
      Basis Universal is a "supercompressed" GPU texture data interchange system
      that supports two highly compressed intermediate file formats (.basis
      or the .KTX2 open standard from the Khronos Group) that can be quickly
      transcoded to a very wide variety of GPU compressed and uncompressed pixel
      formats.
    '';
    homepage = "https://github.com/BinomialLLC/basis_universal";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
