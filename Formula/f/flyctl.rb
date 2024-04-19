class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.40",
      revision: "2aa6a1d61fd5a15f3381e5fbf245b860847c7dc1"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfb006ad9111a05f6aa32d3139ba359c97475f7745e6552d8a18c9ecf0432c2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfb006ad9111a05f6aa32d3139ba359c97475f7745e6552d8a18c9ecf0432c2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfb006ad9111a05f6aa32d3139ba359c97475f7745e6552d8a18c9ecf0432c2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "47ac5f8759a98ab6f19d9e5ee40066631db193e48a96430b13c919f53f7191cf"
    sha256 cellar: :any_skip_relocation, ventura:        "47ac5f8759a98ab6f19d9e5ee40066631db193e48a96430b13c919f53f7191cf"
    sha256 cellar: :any_skip_relocation, monterey:       "47ac5f8759a98ab6f19d9e5ee40066631db193e48a96430b13c919f53f7191cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a16707bf973bfc084151c41876d212585de281456390343d424ab4ff8e0c1e9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
