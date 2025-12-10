class Makeself < Formula
  desc "Generates a self-extracting compressed tar archive"
  homepage "https://makeself.io/"
  url "https://github.com/megastep/makeself/archive/refs/tags/release-2.7.0.tar.gz"
  sha256 "6050d72c56454680c94a3bff8abd4620679c5d5ff13652dbd253f4bf52b85988"
  license "GPL-2.0-or-later"
  head "https://github.com/megastep/makeself.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d9383b9fb664f55f2e38c8aaf54965915fdbccc5750d9bc4b4310246b1351e15"
  end

  def install
    libexec.install "makeself-header.sh"
    # install makeself-header.sh to libexec so change its location in makeself.sh
    inreplace "makeself.sh", '`dirname "$0"`', libexec
    bin.install "makeself.sh" => "makeself"
    man1.install "makeself.1"
  end

  test do
    source = testpath/"source"
    source.mkdir
    (source/"foo").write "bar"
    (source/"script.sh").write <<~SH
      #!/bin/sh
      echo 'Hello Homebrew!'
    SH
    chmod 0755, source/"script.sh"
    system bin/"makeself", source, "testfile.run", "'A test file'", "./script.sh"
    assert_match "Hello Homebrew!", shell_output("./testfile.run --target output")
    assert_equal (source/"foo").read, (testpath/"output/foo").read
  end
end
