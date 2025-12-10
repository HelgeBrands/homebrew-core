class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.141.tgz"
  sha256 "2efa1906eb3b9ad56f4a7c5d24614b993a31084be7448f7263805445434225ea"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "6e17e7b3eebd7bcab78cbc67ecc1ad0732ba3e452facaacc3e68f64806048aa2"
    sha256                               arm64_sequoia: "6e17e7b3eebd7bcab78cbc67ecc1ad0732ba3e452facaacc3e68f64806048aa2"
    sha256                               arm64_sonoma:  "6e17e7b3eebd7bcab78cbc67ecc1ad0732ba3e452facaacc3e68f64806048aa2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c323a61e266173bcf2c154a44877dfe2ef4bb1b1d02dccafbee0e62a97fff901"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20bc51fa0e1c95b67eedd39c350b03b30582594d28cb8c2221c88475000e08d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a63328911e6f2efbce93b51fbdb7514da88e11bc871cbcf84ae3980b0f40a5a3"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
