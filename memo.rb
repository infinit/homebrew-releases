class Memo < Formula

  version "0.9.2"

  desc "Memo Command Line Tools"
  homepage "https://memo.infinit.sh"
  project = "memo"
  url "https://storage.googleapis.com/sh_infinit_releases/osx/#{project}-x86_64-osx-clang3-#{version}.tbz"
  sha256 "b61e0bd891db49398ae948f7b91fa287724bc5ff31e86c730962824912a48365"

  bottle :unneeded

  depends_on :macos => :lion

  def install
    for binary in Dir["bin/*"] do
      bin_path = Pathname.new(binary)
      if File.symlink?(bin_path)
        next
      end
      bin_path.ensure_writable do
        system "install_name_tool", "-delete_rpath", "@loader_path/../lib", "-add_rpath", "@loader_path/../libexec", bin_path
      end
    end
    bin.install Dir["bin/*"]
    libexec.install Dir["lib/*"]
    share.install Dir["share/*"]
  end

  test do
    system "#{bin}/#{project}", "--version"
  end

  def caveats; <<-EOS.undent
    Memo requires FUSE for macOS version 3.x. To install this use:

      brew cask install osxfuse

    Or download it and install it manually from:

      https://github.com/osxfuse/osxfuse/releases

    EOS
  end
end
