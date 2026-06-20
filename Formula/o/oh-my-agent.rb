class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.2.1.tgz"
  sha256 "932a86c7afa550527edf5e993b4928049e5ca255be6170c38431c71fde4b03c2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "86a1ae1e9f8809defc6ce92e0cd19c3a27d2a5b67487493819a69856eaf1ee95"
    sha256 cellar: :any, arm64_sequoia: "0831069f373d0b0120d249fd1329956dcae33a680fe9dae05bff53a1407857ff"
    sha256 cellar: :any, arm64_sonoma:  "0831069f373d0b0120d249fd1329956dcae33a680fe9dae05bff53a1407857ff"
    sha256 cellar: :any, sonoma:        "f2492e452f5ec4fb617fe245e815524a1db9b7a57ffacc115f08ba3a89243d54"
    sha256 cellar: :any, arm64_linux:   "0c3cc711ee42f8c5793e0e665e7ddf68c8f3f83e0b03ecabbe25000a2082248d"
    sha256 cellar: :any, x86_64_linux:  "0974a5daa0e83f1ad64946e722df632e76c60cda26f2a7cb4cc4efb12ba39019"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end
