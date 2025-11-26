class Caqtdm < Formula
  desc "Channel Access Qt Display Manager"
  homepage "https://github.com/caqtdm/caqtdm"
  url "https://github.com/caqtdm/caqtdm/archive/refs/tags/V4.5.0.tar.gz"
  sha256 "153a3d7355a6f6412343b0e2cb876a3dafee06c97e3f1fdcb849320134ee6d1e"
  license "GPLv3"
  head "https://github.com/caqtdm/caqtdm.git", branch: "Development"

  depends_on "qtbase"  => :build
  depends_on "epicsbase" 
  depends_on "qt"
  depends_on "qt5compat"
  depends_on "qtimageformats"
  depends_on "qtnetworkauth"
  depends_on "qtpositioning"
  depends_on "qtserialbus"
  depends_on "qwt"


  def install

    ENV["QTDIR"] = Formula["qt"].opt_prefix
    ENV.append_path "PATH", Formula["qt"].opt_bin
    ENV["EPICS_BASE"] = Formula["epicsbase"].opt_prefix
    ENV["EPICS_HOST_ARCH"] = "darwin-aarch64"
    ENV["EPICSINCLUDE"] = Formula["epicsbase"].opt_prefix
    ENV["EPICSINCLUDE"] += "/include"
    ENV["EPICSLIB"] = Formula["epicsbase"].opt_prefix
    ENV["EPICSLIB"] += "/lib/#{ENV["EPICS_HOST_ARCH"]}"
    ENV["CAQTDM_MODBUS"] = "1"
    ENV["CAQTDM_GPS"] = "1"
    ENV["PRODUCT_BUNDLE_IDENTIFIER"] = "ch.psi.caqtdm"
    ENV["QTDIR"] = Formula["qt"].opt_prefix
    ENV["QTHOME"] = Formula["qt"].opt_prefix
    ENV["QWTHOME"] = Formula["qwt"].opt_prefix
    ENV["CAQTDM_COLLECT"] = prefix.to_s
    ENV["QTCONTROLS_LIBS"] = prefix.to_s
    ENV["QWTVERSION"] = "6.1"
    ENV["QWTLIBNAME"] = "qwt"
    ENV["QWTLIB"] = Formula["qwt"].opt_prefix
    ENV["QWTLIB"] += "/lib"
    ENV["QWTINCLUDE"] = Formula["qwt"].opt_prefix
    ENV["QWTINCLUDE"] += "/lib/qwt.framework/Headers"

    puts ">> Detected QWTLIB: #{ENV["QWTLIB"]}"
    puts ">> Detected QWTINCLUDE: #{ENV["QWTINCLUDE"]}"
    puts ">> Detected qwt: #{Formula["qwt"].opt_prefix}"

    ENV["SDKROOT"] = MacOS.sdk_for_formula(self).path

    os = OS.mac? ? "macx" : OS.kernel_name.downcase
    compiler = ENV.compiler.to_s.match?("clang") ? "clang" : "g++"

    #system "qmake", "PREFIX=#{prefix} release -spec #{os}-#{compiler}"
    system Formula["qtbase"].bin/"qmake", "all.pro", "PREFIX=#{prefix} release -spec #{os}-#{compiler}"
    system "make"
    system "make", "install"
    if OS.mac?
      app_bin = "#{prefix}/caQtDM.app/Contents/MacOS/caQtDM"
      frameworks = "#{prefix}/caQtDM.app/Contents/Frameworks"
      plugins =  "#{prefix}/caQtDM.app/Contents/PlugIns/controlsystems"
      design =  "#{prefix}/caQtDM.app/Contents/PlugIns/designer"

      system "install_name_tool", "-change", "libcaQtDM_Lib.dylib",
             "@rpath/libcaQtDM_Lib.dylib", app_bin
      system "install_name_tool", "-change", "libqtcontrols.dylib",
             "@rpath/libqtcontrols.dylib", app_bin

      system "install_name_tool", "-change", "libcaQtDM_Lib.dylib",
             "@rpath/libcaQtDM_Lib.dylib", "#{plugins}/libepics3_plugin.dylib"
      system "install_name_tool", "-change", "libcaQtDM_Lib.dylib",
             "@rpath/libcaQtDM_Lib.dylib", "#{plugins}/libepics4_plugin.dylib"

     
      system "install_name_tool", "-change", "libcaQtDM_Lib.dylib",
             "@rpath/libcaQtDM_Lib.dylib", "#{plugins}/libarchiveSF_plugin.dylib"
      system "install_name_tool", "-change", "libqtcontrols.dylib",
             "@rpath/libqtcontrols.dylib", "#{plugins}/libarchiveSF_plugin.dylib"      
      system "install_name_tool", "-change", "libcaQtDM_Lib.dylib",
             "@rpath/libcaQtDM_Lib.dylib", "#{plugins}/libarchiveHTTP_plugin.dylib"
      system "install_name_tool", "-change", "libqtcontrols.dylib",
             "@rpath/libqtcontrols.dylib", "#{plugins}/libarchiveHTTP_plugin.dylib"      

      system "install_name_tool", "-change", "libcaQtDM_Lib.dylib",
             "@rpath/libcaQtDM_Lib.dylib", "#{plugins}/libdemo_plugin.dylib"

      system "install_name_tool", "-change", "libcaQtDM_Lib.dylib",
             "@rpath/libcaQtDM_Lib.dylib", "#{plugins}/libenvironment_plugin.dylib"
      system "install_name_tool", "-change", "libqtcontrols.dylib",
             "@rpath/libqtcontrols.dylib", "#{plugins}/libenvironment_plugin.dylib"

      system "install_name_tool", "-change", "libcaQtDM_Lib.dylib",
             "@rpath/libcaQtDM_Lib.dylib", "#{plugins}/libmodbus_plugin.dylib"
      system "install_name_tool", "-change", "libqtcontrols.dylib",
             "@rpath/libqtcontrols.dylib", "#{plugins}/libmodbus_plugin.dylib"

      system "install_name_tool", "-change", "libcaQtDM_Lib.dylib", 
             "@rpath/libcaQtDM_Lib.dylib", "#{plugins}/libgps_plugin.dylib"

      system "install_name_tool", "-change", "@loader_path/libqtcontrols.dylib",
             "#{frameworks}/libqtcontrols.dylib" , "#{frameworks}/libcaQtDM_Lib.dylib"

      system "install_name_tool", "-change", "@loader_path/libadlParser.dylib",
             "#{frameworks}/libadlParser.dylib" , "#{frameworks}/libqtcontrols.dylib" 
      system "install_name_tool", "-change", "@loader_path/libedlParser.dylib",
             "#{frameworks}/libedlParser.dylib" , "#{frameworks}/libqtcontrols.dylib" 

      system "install_name_tool", "-change", "libqtcontrols.dylib",
             "@rpath/libqtcontrols.dylib", "#{design}/libqtcontrols_controllers_plugin.dylib"
      system "install_name_tool", "-change", "libqtcontrols.dylib",
             "@rpath/libqtcontrols.dylib", "#{design}/libqtcontrols_graphics_plugin.dylib"
      system "install_name_tool", "-change", "libqtcontrols.dylib",
             "@rpath/libqtcontrols.dylib", "#{design}/libqtcontrols_monitors_plugin.dylib"
      system "install_name_tool", "-change", "libqtcontrols.dylib",
             "@rpath/libqtcontrols.dylib", "#{design}/libqtcontrols_utilities_plugin.dylib"

      system ("defaults write #{prefix}/caQtDM.app/Contents/Info LSEnvironment -dict QT_PLUGIN_PATH #{prefix}/caQtDM.app/Contents/PlugIns")
      system ("defaults write #{prefix}/caQtDM.app/Contents/Info CFBundleIdentifier -string ch.psi.caQtDM")

      system ("echo '#!/bin/sh' > #{prefix}/caQtDM.app/Contents/Resources/caqtdm")
      system ("echo 'open -n --stdout $(tty) --stderr $(tty) #{prefix}/caQtDM.app --args \"$@\"' >> #{prefix}/caQtDM.app/Contents/Resources/caqtdm")
      system ("echo ' ' >> #{prefix}/caQtDM.app/Contents/Resources/caqtdm")
      system ("chmod 755 #{prefix}/caQtDM.app/Contents/Resources/caqtdm")

      designer_path = "#{prefix}/caQtDM.app/Contents/Resources/caqtdm_designer"
      system ("echo '#!/bin/bash' > #{designer_path}")
      commanddata = "'export DYLD_LIBRARY_PATH=#{prefix}/caQtDM.app/Contents/Frameworks '"
      system ("echo #{commanddata} >> #{designer_path}")
      system ("echo 'export QT_PLUGIN_PATH=#{prefix}/caQtDM.app/Contents/PlugIns ' >> #{designer_path}")
      system ("echo 'exec \"designer\" \"$@\"' >> #{designer_path}")
      system ("echo ' ' >> #{prefix}/caQtDM.app/Contents/Resources/caqtdm_designer")
      system ("chmod 755 #{prefix}/caQtDM.app/Contents/Resources/caqtdm_designer")


      lib.install_symlink prefix/"caQtDM.app/Contents/libqtcontrols.dylib"=> "libqtcontrols.dylib"
      lib.install_symlink prefix/"caQtDM.app/Contents/libcaQtDM_Lib.dylib"=> "libcaQtDM_Lib.dylib"

      bin.install_symlink prefix/"caQtDM.app/Contents/Resources/caqtdm" => "caqtdm"
      bin.install_symlink prefix/"caQtDM.app/Contents/Resources/caqtdm_designer" => "caqtdm_designer"
      bin.install_symlink prefix/"adl2ui.app/Contents/MacOS/adl2ui" => "adl2ui"
      bin.install_symlink prefix/"edl2ui.app/Contents/MacOS/edl2ui" => "edl2ui"
    end
  end

  test do
    # Optional: Ein einfacher Test, ob das Binary da ist
    assert_path_exists bin/"caQtDM.app", :exist?
  end
end
