class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.16.1/liblouis-3.16.1.tar.gz"
  sha256 "7ca90c52c1fb04b22cd976495b2325700c7d0135c929a42707fab7bab03658e9"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 "97393f8dad734bf5f465927f049f72ffeca581df96848b941757420a9a2cc1d9" => :big_sur
    sha256 "b830d1eb331f3e077e98bd04785d8554d3e367fed0b5bdd72aeb57c6987de19f" => :catalina
    sha256 "e430aa275c583c9eb8d5885acde93ccbb0ed154ef82c136c32902a634efa3b33" => :mojave
  end

  head do
    url "https://github.com/liblouis/liblouis.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    cd "python" do
      system "python3", *Language::Python.setup_install_args(prefix)
    end
    mkdir "#{prefix}/tools"
    mv "#{bin}/lou_maketable", "#{prefix}/tools/", force: true
    mv "#{bin}/lou_maketable.d", "#{prefix}/tools/", force: true
  end

  test do
    o, = Open3.capture2(bin/"lou_translate", "unicode.dis,en-us-g2.ctb", stdin_data: "42")
    assert_equal o, "⠼⠙⠃"
  end
end
