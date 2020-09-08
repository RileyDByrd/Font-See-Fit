# Font-Comparer
## Description and Features
Font-Comparer makes comparing fonts easy. By default, the top 30 trending fonts on Google Fonts will be loaded. Select the font that you want to compare, then choose the box that you want to assign the font (left or right). The text that you type at the bottom center of the screen will fill the boxes. If you click on the "Text to Compare" title, it will cycle through some filler text for you. The "Clear Fonts" button empties the ".temp_fonts" folder, which is where downloaded fonts are stored. If you want to compare fonts other than the top 30 trending, you can specify fonts in the .google_webfonts.json file manually.

## Instructions
Just paste your Google Fonts A.P.I. key into a file in the same folder named "api_key", and you should be good to go.

## Dependencies
* [bnagy/bm3-core](https://github.com/bnagy/bm3-core)/lib/bm3-core as .bm3-core in the same folder
  * ffi
  * msgpack
  * beanstalk-client
* google-api-client
* tk

## Ruby and T.K. Environment
Tested on Windows 10 with
* Active T.C.L. 8.6.9
* Ruby 2.7.1p83 (2020-03-31 revision a0c7c23c9c) [x64-mingw32]
* Google A.P.I. Client 0.44.1
* T.K. 0.2.0
* No special configuration

If you get errors during Ruby Devkit installation saying that a Pacman key could not be looked up remotely or get errors during attempted execution that suggest "lib/tcltklib.so" could not be found because of a "loaderror", then you might need to delete your ruby/msys64 folder and replace it with a download from https://www.msys2.org/.
