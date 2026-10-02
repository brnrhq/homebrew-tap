class Brnr < Formula
  desc "Burner phone for your coding agents: run ACP agents behind a reachable host"
  homepage "https://brnrhq.github.io/brnr/"
  license "Apache-2.0"
  head "https://github.com/brnrhq/brnr.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "brnr proxy", shell_output("#{bin}/brnr --help")
    ENV["BRNR_DIR"] = testpath/"run"
    ENV["BRNR_HOME"] = testpath/"home"
    assert_equal "[]", shell_output("#{bin}/brnr list --json").strip
  end
end
