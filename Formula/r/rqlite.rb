class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v9.3.19.tar.gz"
  sha256 "900b5350761135eb1afb7b747060fd9f31861f2e6a734cc596229254395ce8bf"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cf5f20565d84fe4e5a15b8d3c09dfaaf8bd6c322bf39e97da8f4324e2531be3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc658d689ecfa0e702c0ae32c2cd10856ec7f5d37b118124e89c22b936c45e0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b46f6f70de7b848d5a91c1a1053c61e6249ef315a2c9afeb7a206955627809f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a99da7fcf2335b52529da8b73be0bb0f9c498583e3e2d999b2fdf90605bcc4ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bc437c9504cf0a36b1c7a424a5407ce869a1b31b23882a96761a57442c20550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2b711410ef93ffb72011a250e2f164cf74c588e0db5f1138eee9e91e238fff4"
  end

  depends_on "go" => :build

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    version_ldflag_prefix = "-X github.com/rqlite/rqlite/v#{version.major}"
    ldflags = %W[
      -s -w
      #{version_ldflag_prefix}/cmd.Commit=unknown
      #{version_ldflag_prefix}/cmd.Branch=master
      #{version_ldflag_prefix}/cmd.Buildtime=#{time.iso8601}
      #{version_ldflag_prefix}/cmd.Version=v#{version}
    ]
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags:), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    test_sql = <<~SQL
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    SQL

    spawn bin/"rqlited", "-http-addr", "localhost:#{port}",
                         "-raft-addr", "localhost:#{free_port}",
                         testpath
    sleep 5
    assert_match "foo", pipe_output("#{bin}/rqlite -p #{port}", test_sql, 0)
    assert_match "Statements/sec", shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Version v#{version}", shell_output("#{bin}/rqlite -v")
  end
end
