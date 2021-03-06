class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.27.3.tar.gz"
  sha256 "a9d2c8457ba532ca2bbf06312a7b1eb34789119af8ee5b867a11a217d3877272"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "29806c2e4c93c76b38c98707735ecc854d6b05e0a6d949ee986cd90bb97df49b" => :big_sur
    sha256 "26950e212f8519b34d98103441e564e7eb34bdbdc3d8fc86282d8cdf27b5e47b" => :catalina
    sha256 "926229c828c39bf047c021e11012f1ac39300906045c278786abf0ee1cec779b" => :mojave
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
