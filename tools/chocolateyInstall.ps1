# if any command fails, stop immediately.
$ErrorActionPreference = 'Stop'

$packageName = 'JPEGView'
$url = 'https://downloads.sourceforge.net/project/jpegview/jpegview/1.0.37/JPEGView_1_0_37.zip'
$url = 'https://sourceforge.net/projects/jpegview/files/jpegview/1.0.37/JPEGView_1.0.37.zip/download'
$sha256 = 'f0d6c62bc7c5aa49a7a8f45294d8199355d7c1a940df5a322dc163effad22591'

$osBitness = Get-ProcessorBits

# the gist is quite simple:
# 1. create a tmp subdirectory under the directory where the package
#    will be installed (e.g. C:\ProgramData\chocolatey\lib\jpegview.1.0.32.1\tools\tmp)
#
#    the tools subdirectory is given by:
#
#      Split-Path -parent $MyInvocation.MyCommand.Definition
#
# 2. download the JPEGView zip file and extract it to the tmp directory.
# 3. copy the 32 or 64 bits binaries to the app subdirectory.
# 4. remove the temporary directory.
# 5. associate several image file extensions with the installed application.

$toolsPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$appPath = "$toolsPath\app"
$jpegviewPath = Join-Path $appPath "$($packageName).exe"
$tmpPath = Join-Path $toolsPath tmp
$extractPath = Join-Path $tmpPath $packageName

Install-ChocolateyZipPackage $packageName $url $extractPath -ChecksumType sha256 -Checksum $sha256 
New-Item -Type Directory $appPath | Out-Null
Move-Item (Join-Path $extractPath "JPEGView$osBitness\*") $appPath
Remove-Item -Force -Recurse $tmpPath

# XXX setting the file association is so slow (it starts another shell)
# NB Starting on Windows 8, file associations cannot be really changed by
#    simply writting on the registry... we, as a user, still need to
#    right-click the file and select the "Open With" option. so sad...
# See Application Registration at http://msdn.microsoft.com/en-us/library/windows/desktop/ee872121(v=vs.85).aspx
# See How File Associations Work at http://msdn.microsoft.com/en-us/library/windows/desktop/dd758090(v=vs.85).aspx
# NB this creates, at least, the following registry keys:
#      [HKEY_LOCAL_MACHINE\Software\Classes\JPEGView.exe\shell\open\command]
#       @="\"C:\\Program Files\\JPEGView\\JPEGView.exe\" \"%1\" \"%*\""
#      [HKEY_LOCAL_MACHINE\Software\Classes\Applications\JPEGView.exe\shell\open\command]
#       @="\"C:\\Program Files\\JPEGView\\JPEGView.exe\" \"%1\" \"%*\""
#    and modifies the following values:
#      [HKEY_CLASSES_ROOT\.png]
#      @="JPEGView.exe"
#      [HKEY_CLASSES_ROOT\.png\OpenWithProgIds]
#      "JPEGView.exe"=""
Install-ChocolateyFileAssociation ".png" $jpegviewPath
Install-ChocolateyFileAssociation ".jpg" $jpegviewPath
Install-ChocolateyFileAssociation ".jpeg" $jpegviewPath
Install-ChocolateyFileAssociation ".webp" $jpegviewPath
Install-ChocolateyFileAssociation ".bmp" $jpegviewPath
