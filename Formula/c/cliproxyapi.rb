class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.62.tar.gz"
  sha256 "777d5852fb486b36231affdd587375dc7e5d28061a00bd2ad66217a0ebf7ec91"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "296dd458a04aaa53a3472316a96a8ac4b8c0897c3896d69bb632da0da68ecf3f"
    sha256                               arm64_sequoia: "296dd458a04aaa53a3472316a96a8ac4b8c0897c3896d69bb632da0da68ecf3f"
    sha256                               arm64_sonoma:  "296dd458a04aaa53a3472316a96a8ac4b8c0897c3896d69bb632da0da68ecf3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0e85686ee293a5be7508f83aa92fa1f61d4f40bda9bd9e1f1a3f5c4716f05fe"
    sha256                               arm64_linux:   "a5f5b2e32f524502d7e9eeca46fcea80d5087b7de7f2ba63d858a92bc4c1826c"
    sha256                               x86_64_linux:  "9cf0f816ccc1bb20068ae406fdd1c2dd785b6e108dc4f29edd5ba0e0afc6b176"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
      -X main.BuildDate=#{time.iso8601}
      -X main.DefaultConfigPath=#{etc/"cliproxyapi.conf"}
    ]

    system "go", "build", *std_go_args(ldflags:), "cmd/server/main.go"
    etc.install "config.example.yaml" => "cliproxyapi.conf"
  end

  service do
    run [opt_bin/"cliproxyapi"]
    keep_alive true
  end

  test do
    require "pty"
    PTY.spawn(bin/"cliproxyapi", "-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end
