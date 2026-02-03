class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.27.6.tar.gz"
  sha256 "2d1fe872c21a4e6ee5663959760cf41b10c27bc6ed4bbc87ce8fac68ad156e1e"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9d19418d6a5293585661172fb17d1786b9a06c18f9b2e341088a08b363106e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d47b1d618601670add35d50401b976ac580d8dc5c22e92280b342fd3a25691e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e9642280f7c436a27f05165b6e71dd2228e44b37855ea4d7cfe64c8c45f6064"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd784a546d47d66952b8cba86ab76640305cd3328224b9814dc33328c6dfccfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0627e1b8d734b489fd4b9a17924ec8702b5c064f091ccd34e66dbda13921d68c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d530252f2ca1bca3502c0105b1f5fa839cc858a175765c8590c4cb456511a0d1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
