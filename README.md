<p align="center">
  <a href="" rel="noopener">
 <img width=200px height=200px src="https://i.imgur.com/fwbb6JT.png" alt="Project logo"></a>
</p>

<h3 align="center">LANraragi Plugins</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![GitHub Issues](https://img.shields.io/github/issues/Nixis198/LANraragi-Plugins.svg)](https://github.com/Nixis198/LANraragi-Plugins/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/Nixis198/LANraragi-Plugins.svg)](https://github.com/Nixis198/LANraragi-Plugins/pulls)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> Just a few plugins I wrote for the program <a href="https://github.com/Difegue/LANraragi/">LANraragi</a>. They are written for using <a href="https://www.nhentai.net/">nHentai</a> and <a href="https://doujindownloader.com/">HDoujin Downloader</a>.
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Future Plans](#plans)
- [Authors](#authors)
- [Acknowledgments](#acknowledgement)

## 🧐 About <a name = "about"></a>

This repository currently contains 3 plugins. ID Tag Adder, Source Adder, and nHentai Lookup Using Hdoujin.
In order for you to use them you must have an info.txt file in the archive that follows the Hdoujin Downloader v2 format. Or really just an info.txt file that has the line "URL:" with the URL after it.
These plugins have only been tested using nHentai and the info.txt from Hdoujin. I have no idea if they will work with other websites too.

## 🏁 Getting Started <a name = "getting_started"></a>

In order to install the plugins go to the homepage of LANraragi click on "Settings" then "Plugin Configuration" then "Upload Plugin" at the bottom. At this point just select the plugins you want to install and click open. TIP: You can install as many plugins as you want at once. No need to upload plugins one at a time.

## 🎈 Usage <a name="usage"></a>

Once you installed the plugins give the page a refresh so you can see the plugins. All three plugins are under the "Metadata Plugins" tab.
The only setting for each of the plugins is a toggle for the "Auto-Plugin" setting.
What this means is it will run the plugin if Shinobu detects a new archive.
You can use all three plugins with the "Batch Tagging", but be warned that the "nHentai Lookup Using Hdoujin" plugin does ping the nHentai servers and you can get IP banned.
If you want to use this plugin with batch tagging I recommend using a 15-20 second delay between each archive.

This is split up into 3 different parts for each of the plugins.

### ID Tag Adder
This plugin adds the gallery ID of the archive as its own tag. IE if the URL of the archive is "nhentai.net/g/177013" it will add the tag "ID:177013" to the archive.

### Source Tag Adder
This plugin will add the url of the archive as a tag. IE if the URL of the archive is "nhentai.net/g/177013" it will add the tag "source:nhentai.net/g/177013/" to the archive.

### nHentai Lookup Using Hdoujin
This plugin will use the URL found in the info.txt file in the archive to change the title and get the tags for the archive. This is much more reliably then just looking up the title.


## 📝 Future Plans <a name = "plans"></a>

- Give the plugins better names.
- Add a toggle setting to nHentai Lookup Using Hdoujin where it won't change the name of the archive.
- Test/add support for other websites.
## ✍️ Authors <a name = "authors"></a>

- [@Nixis198](https://github.com/Nixis198) - Wrote the plugins.

## 🎉 Acknowledgements <a name = "acknowledgement"></a>

- [@Defegue](https://github.com/Difegue) - For making LANraragi which the plugins are used with.
