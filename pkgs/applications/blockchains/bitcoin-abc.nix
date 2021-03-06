{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, autoreconfHook, openssl, db53, boost
, zlib, miniupnpc, qtbase ? null , qttools ? null, utillinux, protobuf, qrencode, libevent
, withGui }:

with stdenv.lib;

mkDerivation rec {

  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-abc-" + version;
  version = "0.20.7";

  src = fetchFromGitHub {
    owner = "bitcoin-ABC";
    repo = "bitcoin-abc";
    rev = "v${version}";
    sha256 = "1d17ry9906zmwj2n3mh77b6rqmdg0dgm7b7ybh8d7q2ml0196ilj";
  };

  patches = [ ./fix-bitcoin-qt-build.patch ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db53 boost zlib
                  miniupnpc utillinux protobuf libevent ]
                  ++ optionals withGui [ qtbase qttools qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt5" ];

  enableParallelBuilding = true;

  meta = {
    description = "Peer-to-peer electronic cash system (Cash client)";
    longDescription= ''
      Bitcoin ABC is the name of open source software which enables the use of Bitcoin.
      It is designed to facilite a hard fork to increase Bitcoin's block size limit.
      "ABC" stands for "Adjustable Blocksize Cap".

      Bitcoin ABC is a fork of the Bitcoin Core software project.
    '';
    homepage = https://bitcoinabc.org/;
    maintainers = with maintainers; [ lassulus ];
    license = licenses.mit;
    broken = stdenv.isDarwin;
    platforms = platforms.unix;
  };
}
