class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.21.tar.gz"
  sha256 "64a69e43ce183810505e5c82e868029ca2e7d2292b9a254e5a59a537bd6146d6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3905d2c2048294e95c53db968e3f67260f778171dbfb19b433be11da1a934f4f"
    sha256 cellar: :any,                 arm64_sequoia: "60bb9d264454b8311a4b95435f2f02f46598a9458b3ef520c9be99385d85cbb1"
    sha256 cellar: :any,                 arm64_sonoma:  "8da1036657501c95c90422b22d2ff75df1db4ba1e12e6039c0c3fba1e57b470c"
    sha256 cellar: :any,                 sonoma:        "e86c783dd1c2937cee6ac6cca553c4dcd6ba18991c342094bcf3042aa4b586f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca00aa0753b0f6f732343f3b00befcfb85c6f06c3e60c7593c1898c635c5c147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75aac54684f2c9a3c3f3d8ce676c912dc5744c414d59ed7bd1f075c626c7b90f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c2patool -V").strip

    (testpath/"test.json").write <<~JSON
      {
        "assertions": [
          {
            "label": "com.example.test",
            "data": {
              "my_key": "my_value"
            }
          }
        ]
      }
    JSON

    system bin/"c2patool", test_fixtures("test.png"), "-m", "test.json", "-o", "signed.png", "--force"

    output = shell_output("#{bin}/c2patool signed.png")
    assert_match "\"issuer\": \"C2PA Test Signing Cert\"", output
  end
end
