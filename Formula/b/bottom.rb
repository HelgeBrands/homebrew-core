class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.13.0.tar.gz"
  sha256 "e71c763ae9188f0396e33fc2ffbb6b9872eb2a317188750860cef3ca19b8985e"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "477151ad275888b8b03442080b22ffb70bfce7b0dec2165f3673a0807607a2c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73d628c5d61a6fb6a46a11138db324d23045dfd69ac212a39506bcee626608ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9798b7c98ac8ec576e543f3d6d3af705853451b9b001c878145645bfcd03394e"
    sha256 cellar: :any_skip_relocation, sonoma:        "64f0c6ce8ed1c3c78e9cbaf4c25eba4d96ef147ee9e83220c9af47d13ebe6a44"
    sha256 cellar: :any,                 arm64_linux:   "a3af3f006506696cf618bab43e99221a4f6fe3a27284bcf8760504fb5005e125"
    sha256 cellar: :any,                 x86_64_linux:  "cb831635af1b76b04f4a9769c1fa2f6dc474b79e8c3ea08a7cba7ee156794e9d"
  end

  depends_on "rust" => :build

  def install
    # enable build-time generation of completion scripts and manpage
    ENV["BTM_GENERATE"] = "true"

    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = "target/tmp/bottom"
    bash_completion.install "#{out_dir}/completion/btm.bash" => "btm"
    fish_completion.install "#{out_dir}/completion/btm.fish"
    zsh_completion.install "#{out_dir}/completion/_btm"
    pwsh_completion.install "#{out_dir}/completion/_btm.ps1"
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output("#{bin}/btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output("#{bin}/btm --invalid 2>&1", 2)
  end
end
