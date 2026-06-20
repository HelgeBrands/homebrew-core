class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.20.3",
      revision: "d751b41019ff8abfe7218538baa8cb8959ea4338"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9a66f2146c81b135e7c40f4230a2759a7a33e04f17de24cf221a99a58311630"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9a66f2146c81b135e7c40f4230a2759a7a33e04f17de24cf221a99a58311630"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9a66f2146c81b135e7c40f4230a2759a7a33e04f17de24cf221a99a58311630"
    sha256 cellar: :any_skip_relocation, sonoma:        "cce270332d783e872c8621f99fe2e45b13d97a5269119371178d93688c895858"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1828d99d1f886c727202dfd169b1c03058204bc2e0068be391569db92346196c"
    sha256 cellar: :any,                 x86_64_linux:  "e85b047d282fae9a5738cb5e1de85059c3f77c8dff5a93deac1274ef751d0557"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
