class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "306e6068d0da6dae875cad3929ca0ce91e2aea98d4ba9b4f23f1286b47df4b41"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d369984ca17acc91c933ec0aa442654f88b3f78c11ed07aa39e21c5e955bfc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db6217336f27ee9a34d3bbf654c7f453e9d4ae000e9cd7b601a4a24c8b5fd157"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a048abae592f71ba97384109860f94a81913a381fe45c67c51737e1c555387ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "651d655669e77ca5c045f02d0716617b38aac3c1a42bbbcd1021353c8097c831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc9920c1eacd7f18f3be7675a18ef012e8877dd5c8e13a1ce1640e205017c3fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9558fe86462f17790d5dca87205510d2777c4a781b7f4295c23d035d87c47a4c"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end
