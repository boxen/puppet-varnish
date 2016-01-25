require 'formula'

class Varnish < Formula
  desc "High-performance HTTP accelerator"
  homepage "https://www.varnish-cache.org/"
  url "https://repo.varnish-cache.org/source/varnish-4.1.0.tar.gz"
  sha256 "4a6ea08e30b62fbf25f884a65f0d8af42e9cc9d25bf70f45ae4417c4f1c99017"
  version '4.1.0-boxen1'

  bottle do
    sha256 "0eda704c372f73437ee8b29d3d4183f69672e074ceceadae56b630d9f86499e8" => :el_capitan
    sha256 "aaf399bcddbaec19f164834f6a514a573f9a6016048805729693ff199267ad06" => :yosemite
    sha256 "b5fda8068aa76e6f580c334ada855796d911a6223150c782696c014968abed51" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "pcre"

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.11.tar.gz"
    sha256 "9af4166adf364447289c5c697bb83c52f1d6f57e77849abcccd6a4a18a5e7ec9"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", buildpath+"lib/python2.7/site-packages"
    resource("docutils").stage do
      system "python", "setup.py", "install", "--prefix=#{buildpath}"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--with-rst2man=#{buildpath}/bin/rst2man.py",
                          "--with-rst2html=#{buildpath}/bin/rst2html.py"
    system "make", "install"
    (etc+"varnish").install "etc/example.vcl" => "default.vcl"
    (var+"varnish").mkpath
  end

  test do
    system "#{opt_sbin}/varnishd", "-V"
  end
end