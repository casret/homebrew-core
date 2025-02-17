class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://github.com/asdf-vm"
  url "https://github.com/asdf-vm/asdf/archive/v0.7.6.tar.gz"
  sha256 "df1811b3fb9b373cdf8899e1bbe18aadaff8d48c9a4ce5ef8db18269a20c0137"
  head "https://github.com/asdf-vm/asdf.git"

  bottle :unneeded

  depends_on "autoconf"
  depends_on "automake"
  depends_on "coreutils"
  depends_on "libtool"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "readline"
  depends_on "unixodbc"

  conflicts_with "homeshick",
    :because => "asdf and homeshick both install files in lib/commands"

  def install
    bash_completion.install "completions/asdf.bash"
    zsh_completion.mkpath
    cp "#{bash_completion}/asdf.bash", zsh_completion
    (zsh_completion/"_asdf").write <<~EOS
      #compdef asdf
      _asdf () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/asdf.bash
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
    fish_completion.install "completions/asdf.fish"
    libexec.install "bin/private"
    prefix.install Dir["*"]
  end

  test do
    output = shell_output("#{bin}/asdf plugin-list 2>&1", 1)
    assert_match "Oohes nooes ~! No plugins installed", output
  end
end
