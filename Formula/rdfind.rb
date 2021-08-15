class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.5.0.tar.gz"
  sha256 "4150ed1256f7b12b928c65113c485761552b9496c433778aac3f9afc3e767080"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?rdfind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "354f66f386e4ea54db4efcdeca59c897fa985ec2567ec7677eb62e1d975bbf6c"
    sha256 cellar: :any,                 big_sur:       "ade2aaffee4c52e143fdcd0a22fae933e60e4c3d5057e4bc74a9aaffaf3c2146"
    sha256 cellar: :any,                 catalina:      "e890406a4cbbd8d026a4c583644efa537433ac71c095a1e582b0454d85a87d00"
    sha256 cellar: :any,                 mojave:        "489e104d2c5e5d939439f5b100cd97e19ed070181d355b49fbd1ad2b3320d789"
    sha256 cellar: :any,                 high_sierra:   "2ce91e3b8a129c0fadb57fba46074e74e0d896287c23eb1844cd99e5eef093b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f27f8e434303de8a0af302a38e6734b74f7044f3795bee5a5f2a8a0c2427145f"
  end

  depends_on "nettle"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "folder"
    (testpath/"folder/file1").write("foo")
    (testpath/"folder/file2").write("bar")
    (testpath/"folder/file3").write("foo")
    system "#{bin}/rdfind", "-deleteduplicates", "true", "folder"
    assert_predicate testpath/"folder/file1", :exist?
    assert_predicate testpath/"folder/file2", :exist?
    refute_predicate testpath/"folder/file3", :exist?
  end
end
