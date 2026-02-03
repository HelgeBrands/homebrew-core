class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "c6dee9dee30efdc6770709e38f3f140a0401f7c63504e1c9181c155643925465"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db6d3539b33c39ce21ff1d7562265c4f12b8b788ff15baaac76254ec87585a88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74b5d51457a41399e418b72d91e707126f33250d8a739af4de25c7aaf1656356"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40aa6ae7ee48e2e6315149a8eec4194e9fe138115591bd927ea67ae782cc38d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "94f38bf6cf1aebafed950d0e5494e9ca4f22868e6ac553f68ca1fde2db990a0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eff0a2d7841726a17737d786675cd1c2657dbe74b9b494c30251461f1a9bfe8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70d3ec255602a207f63ae40afc2865294e43e7e18dc8e5e88c794f6bc0e97f38"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - apk-tools

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath/"apko-alpine.tar"

    assert_match version.to_s, shell_output("#{bin}/apko version")
  end
end
