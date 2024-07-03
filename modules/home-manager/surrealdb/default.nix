{ lib
, stdenv
, fetchFromGitHub
, cargo
, pkg-config
, protobuf
, rustPlatform
, rustc
, bzip2
, openssl
, zstd
, darwin
, rocksdb
}:

stdenv.mkDerivation rec {
  pname = "surrealdb";
  version = "2.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealdb";
    rev = "v${version}";
    hash = "sha256-iAsKIXJk52Lbbx5nK01gnN51afZ5XfNV0p+KgL54e6A=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-LHBvpWFt1GpHKAqWyvPv8uQvdNBMLTwfXEz26sdUiuU=";
  };

  nativeBuildInputs = [
    cargo
    pkg-config
    protobuf
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
  ];

  buildInputs = [
    bzip2
    openssl
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "A scalable, distributed, collaborative, document-graph database, for the realtime web";
    homepage = "https://github.com/surrealdb/surrealdb";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [ ];
    mainProgram = "surrealdb";
    platforms = platforms.all;
  };
}
