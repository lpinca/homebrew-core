class Rtptools < Formula
  desc "Set of tools for processing RTP data"
  homepage "https://web.archive.org/web/20190924020700/www.cs.columbia.edu/irt/software/rtptools/"
  url "https://github.com/irtlab/rtptools/archive/1.22.tar.gz"
  sha256 "ac6641558200f5689234989e28ed3c44ead23757ccf2381c8878933f9c2523e0"
  license "BSD-3-Clause"
  head "https://github.com/irtlab/rtptools.git"

  livecheck do
    url :head
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "a9f1e8f18d40ba8b435f619de132a5fbc00e0ef84d5a1e10378700e0f3ce417b" => :big_sur
    sha256 "a760c9b142e55aba7732406eeb2603c49b9b7514e02bd01bc245d0661772bf20" => :arm64_big_sur
    sha256 "59fa4c8c53c3430c6bb47b82c752eef710f692ad3fb1bd3ab82c108524aabe00" => :catalina
    sha256 "eb8412186a92c44426b2f4c4bef7adcffb308afd4bb036a2dd9d1a0d184b504e" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    packet = [
      0x5a, 0xb1, 0x49, 0x21, 0x00, 0x0d, 0x21, 0xce, 0x7f, 0x00, 0x00, 0x01,
      0x11, 0xd9, 0x00, 0x00, 0x00, 0x18, 0x00, 0x10, 0x00, 0x00, 0x06, 0x8a,
      0x80, 0x00, 0xdd, 0x51, 0x32, 0xf1, 0xab, 0xb4, 0xdb, 0x24, 0x9b, 0x07,
      0x64, 0x4f, 0xda, 0x56
    ]

    (testpath/"test.rtp").open("wb") do |f|
      f.puts "#!rtpplay1.0 127.0.0.1/55568"
      f.write packet.pack("c*")
    end

    output = shell_output("#{bin}/rtpdump -F ascii -f #{testpath}/test.rtp")
    assert_match "seq=56657 ts=854698932 ssrc=0xdb249b07", output
  end
end
