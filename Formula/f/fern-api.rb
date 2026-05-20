class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.32.0.tgz"
  sha256 "05bc7eac031e5ec72df7469d0217e04663491b26c20ca1160f3b4f7331b9b88e"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4aeca2995b82c0e104cdf2a08cb735603bf769b030346703f6ca1d863261bfce"
    sha256 cellar: :any,                 arm64_sequoia: "460e77b94a536ce974b3df271dead05e7a35b7659a5f2434e8328853770af9c3"
    sha256 cellar: :any,                 arm64_sonoma:  "460e77b94a536ce974b3df271dead05e7a35b7659a5f2434e8328853770af9c3"
    sha256 cellar: :any,                 sonoma:        "75a84ac2bf4cdfc9f79b11f48430148ddbb0401144eaf39cfe3c26ae6d01ad66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1a28dd59f6d739cdc7d6ded3bafd95847be469c5c4ecd1a8d7f7cfbec61995d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7194beb0b7022098d25ed751e94f97dfd5f9e2672c1439aa98e548b2ef6092a"
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
