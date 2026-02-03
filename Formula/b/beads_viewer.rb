class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "4791924f593cab7a9af2796c57ffe28eb7b2fa71cf6c13453ed1197a82d5301c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ddf9d694fef3e128701459f700fec0cfe701f05b859280a9c7a5d273f8b0f1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ddf9d694fef3e128701459f700fec0cfe701f05b859280a9c7a5d273f8b0f1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ddf9d694fef3e128701459f700fec0cfe701f05b859280a9c7a5d273f8b0f1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e4b9402e44a63b1d8406c6b644588c0221215a7f5c615f64fe0b2ded99fc203"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eceb5a244fd4dd79c5a5cec0465dff547b0124b9d8467e01493c2cb13b956f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0d27684eb4a3f51b87ba721fae8fb7d9cd83e4b0773ed20b09abe2453d354ad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Dicklesworthstone/beads_viewer/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bv"), "./cmd/bv"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/bv --version")

    # Test that it detects missing .beads directory.
    output = shell_output("#{bin}/bv --robot-insights 2>&1", 1)
    assert_match "failed to read beads directory", output
  end
end
