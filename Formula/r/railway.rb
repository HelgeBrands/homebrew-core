class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.19.0.tar.gz"
  sha256 "4c30c110fa8023f4216e63b4bdf24b0e617ac86f98e30de3a69b64cb97e9be54"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42e821b96d166b9a7fb444734466b5dcbe27c728bedafb47940bcf1a5080b661"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d34fd6288731cfcc1e387b36867a916b85f5a9a4daee4df4fc37062a99931571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd69be702d9a0ff0270d61b9a43fb50f795be53245daa20d63b22e5c9edb89bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "cce888b954d61342758196d1e7335e8ed22ea242ebe51a15e73f2a4605644241"
    sha256 cellar: :any,                 arm64_linux:   "f357907dd220b67b6a47c1721a63c20c6f42a0eaed3b38ffdbd81ec79e00ec95"
    sha256 cellar: :any,                 x86_64_linux:  "7e2a6772887a1ed1e8d6d5d275f7b2a6ea74faf01a3efe8d98b21e2870b05a95"
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
