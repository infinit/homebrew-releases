class Infinit < Formula

  version "0.8.0"

  desc "Infinit File System Command Line Tools"
  homepage "https://infinit.sh"
  url "https://storage.googleapis.com/sh_infinit_releases/osx/infinit-x86_64-osx-clang3-#{version}.tbz"
  sha256 "a4c93acd6528066cebc1a69e2b19513cb2463c6ad3c74d585b0ed464758cde5b"

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
    system "#{bin}/infinit", "--version"
  end

  def caveats; <<-EOS.undent
    Infinit requires FUSE for macOS version 3.x. To install this use:

      brew cask install osxfuse

    Or download it and install it manually from:

      https://github.com/osxfuse/osxfuse/releases

    EOS
  end
end
