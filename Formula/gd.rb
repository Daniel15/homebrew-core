class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  revision 1

  stable do
    url "https://github.com/libgd/libgd/releases/download/gd-2.2.4/libgd-2.2.4.tar.xz"
    sha256 "137f13a7eb93ce72e32ccd7cebdab6874f8cf7ddf31d3a455a68e016ecd9e4e6"

    patch do
      url "https://github.com/libgd/libgd/commit/381e89de.patch"
      sha256 "5604fb87dfaabff0ae399bb6f6ed0fbe01dbb8a63db9cead85623c7bc63d4963"
    end
  end

  bottle do
    cellar :any
    sha256 "23a18720365fd4c7aaa4d8097f339ef4177a5d708990db6711f72661d04035c9" => :sierra
    sha256 "f466f3c052633de8e1a649345890e3da2579791a8876e8ddc81e582654319e92" => :el_capitan
    sha256 "b1db65caa81c5bfdcf16b63b44dcbccbad82a7007111479a5a94a2bbc497a2d1" => :yosemite
    sha256 "e377d7b9bd03d97f0de81a1d46c637a9fd5d907911803af1d76dc04af5819711" => :x86_64_linux
  end

  head do
    url "https://github.com/libgd/libgd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "fontconfig" => :recommended
  depends_on "freetype" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "webp" => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
      --without-xpm
    ]

    if build.with? "libpng"
      args << "--with-png=#{Formula["libpng"].opt_prefix}"
    else
      args << "--without-png"
    end

    if build.with? "fontconfig"
      args << "--with-fontconfig=#{Formula["fontconfig"].opt_prefix}"
    else
      args << "--without-fontconfig"
    end

    if build.with? "freetype"
      args << "--with-freetype=#{Formula["freetype"].opt_prefix}"
    else
      args << "--without-freetype"
    end

    if build.with? "jpeg"
      args << "--with-jpeg=#{Formula["jpeg"].opt_prefix}"
    else
      args << "--without-jpeg"
    end

    if build.with? "libtiff"
      args << "--with-tiff=#{Formula["libtiff"].opt_prefix}"
    else
      args << "--without-tiff"
    end

    if build.with? "webp"
      args << "--with-webp=#{Formula["webp"].opt_prefix}"
    else
      args << "--without-webp"
    end

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pngtogd", test_fixtures("test.png"), "gd_test.gd"
    system "#{bin}/gdtopng", "gd_test.gd", "gd_test.png"
  end
end
