class Infinit < Formula

  version "0.6.2"

  desc "Infinit File System Command Line Tools"
  homepage "https://infinit.sh"
  url "https://storage.googleapis.com/sh_infinit_releases/osx/infinit-x86_64-osx-clang3-#{version}.tbz"
  sha256 "07903e8af3bb06ab881f878091c427edf3ccafba1dc20d4a49d9dfd00bd8cb21"

  bottle :unneeded

  depends_on :macos => :lion

  def absolute_rpath(binary)
    bin_path = Pathname.new(binary)
    libraries = bin_path.dynamically_linked_libraries
    bin_path.ensure_writable do
      for dep_lib in libraries do
        if dep_lib.include? "@rpath"
          new_lib = (String.new(dep_lib).sub! "@rpath", libexec)
          system "install_name_tool", "-change", dep_lib, new_lib, bin_path
        end
      end
    end
  end

  def install
    for binary in Dir["bin/*"] do
      absolute_rpath(binary)
    end
    for library in Dir["lib/*"] do
      absolute_rpath(library)
    end
    bin.install Dir["bin/*"]
    libexec.install Dir["lib/*"]
    share.install Dir["share/*"]
  end

  test do
    system "#{bin}/infinit-user", "--version"
  end

  def caveats; <<-EOS.undent
    Infinit requires FUSE for macOS version 3.x. To install this use:

      brew cask install osxfuse-beta

    Or download it and install it manually from:

      https://github.com/osxfuse/osxfuse/releases

    EOS
  end
end
