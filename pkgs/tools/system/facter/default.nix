{ stdenv, fetchFromGitHub, boost, cmake, cpp-hocon, curl, leatherman, libwhereami, libyamlcpp, openssl, ruby, utillinux }:

stdenv.mkDerivation rec {
  name = "facter-${version}";
  version = "3.12.2";

  src = fetchFromGitHub {
    sha256 = "021z0r6m5nyi37045ycjpw0lawvw70w4pjl56cj1mwz99pq1qqns";
    rev = version;
    repo = "facter";
    owner = "puppetlabs";
  };

  CXXFLAGS = "-fpermissive -Wno-error=catch-value";
  NIX_LDFLAGS = "-lblkid";

  cmakeFlags = [ "-DFACTER_RUBY=${ruby}/lib/libruby.so" ];

  # since we cant expand $out in cmakeFlags
  preConfigure = "cmakeFlags+=\" -DRUBY_LIB_INSTALL=$out/lib/ruby\"";

  buildInputs = [ boost cmake cpp-hocon curl leatherman libwhereami libyamlcpp openssl ruby utillinux ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/puppetlabs/facter;
    description = "A system inventory tool";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };
}
