class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.57.0.tgz"
  sha256 "592b6b1b2e3782015a6d2f7fe544255241d0b20515fef4bd75cdc37904beed35"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71f847ef24bdf6c6565034481ee910411a3cb5a73f80459be52137573fff2cbb"
    sha256 cellar: :any,                 arm64_sequoia: "85b3d2fcade8ce20ef7d0c8b09336143607e88d92d88d9813d1e313044b28ed1"
    sha256 cellar: :any,                 arm64_sonoma:  "85b3d2fcade8ce20ef7d0c8b09336143607e88d92d88d9813d1e313044b28ed1"
    sha256 cellar: :any,                 sonoma:        "a95959c50a5157a5d8a7e3d5761ad3197667e2f349a4de21386710a96f34956c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47309eb18d2d4916862e128a381d87a6283d68c45e796ce02e5d898e5c470795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ac0b0ce43d780572e322fc99e69ce00222c1aa4d131bc49f1a6546400db586"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
