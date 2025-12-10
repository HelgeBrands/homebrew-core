class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "71fdb9cc8abc6d84f4f62499a181c2933c7b95f3942d757ee747aa0f040c4eac"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "660799b9a063f35506d52ae47e465e065251cbbf27c53b59bd79105d4b16d509"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "660799b9a063f35506d52ae47e465e065251cbbf27c53b59bd79105d4b16d509"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "660799b9a063f35506d52ae47e465e065251cbbf27c53b59bd79105d4b16d509"
    sha256 cellar: :any_skip_relocation, sonoma:        "29e86af27c78e14321485af530af89bfa9905d31bb12e83679ca8271cfa5022a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7ec4ac9cccd957389f52a803065a31b559be1ea6048258cbe97c67828d607e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5d493304f8086c9eb851c6f0c02a29a9715eaae224ea54bfeb529d7a93509f4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end
