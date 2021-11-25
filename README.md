
Forked from selfire, changes include:
* Addition of Header and Notes sections for status and comments respectively
  * Header section for status and general related connection
  ```
      Related:
      Status: #📖/🟥
      ```
  * Notes section to easily put in comments across verses.
      ```
      i.e # Notes

      # 1-3

      Note on Verse 1-3 which then can be referenced in any note like so:
       [[<Book & Chapter>#1-3]] i.e [[Genesis 1#1-3]]

      ```
* Long format book names, makes it easier to read whilst also enabling header references as verses.
  ```
  This is enables <Book & Chapter>#<Header> format, rather than <Book & Chapter|Alias format.

  i.e Genesis 1#1-3 (Displayed as Genesis 1>1-3) instead of Gen-01#1-3|Genesis 1 (Displayed as 'Genesis 1' - specific reference is lost)

  ```

  You can just use Gen-01#1-3 (Displayed as Gen-01>1-3) but it is a bit harder to read. (If preferred, then uncomment line 101 and comment out 102 and this will revert to the previous format)  
* Added  `bg2md.rb` for connivence from [jgclark/BibleGateway-to-Markdown](https://github.com/jgclark/BibleGateway-to-Markdown), so this script should work out of the box.

# BibleGateway-to-Obsidian
This script adapts [jgclark's BibleGateway-to-Markdown](https://github.com/jgclark/BibleGateway-to-Markdown) script to export for use in [Obsidian](https://obsidian.md/). It accompanies a [Bible Study in Obsidian Kit](https://forum.obsidian.md/t/bible-study-in-obsidian-kit-including-the-bible-in-markdown/12503?u=selfire) that gets you hands-on with using Scripture in your personal notes.

What the script does is fetch the text from [Bible Gateway](https://www.biblegateway.com/) and save it as formatted markdown file. Each chapter is saved as one file and navigation between files as well as a book-file is automatically created. All of the chapter files of a book are saved in its numbered folder.

This script is intended to be as simple as possible to use, even if you have no idea about Scripting. If you have any questions, please reach out to me either on github or Discord (`selfire#3095`).
***
> You can help me keep creating tools like this by [buying me a coffee](https://www.buymeacoffee.com/joschua) ☕️.

<a href="https://www.buymeacoffee.com/joschua" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height= "48" width="173"></a>


## Important Disclaimers
* This is not affiliated to, or approved by, BibleGateway.com. In my understanding it fits into the [conditions of usage](https://support.biblegateway.com/hc/en-us/articles/360001398808-How-do-I-get-permission-to-use-or-reprint-Bible-content-from-Bible-Gateway-?) but I make no guarantee regarding the usage of the script, it is at your own disgression.
* By default, the version is set to the [WEB Bible](https://worldenglish.bible/). You can change the version, as long as you honour the copyright standards of different translations of the Bible (See: [BibleGateways overview](https://www.biblegateway.com/versions/)).
* I have little experience in scripting–through this project I taught myself bash and regex basics. If you run into issues or have a way to simplify this script, please raise an issue or reach out on Discord (`selfire#3095`).

## Installation
Here are the tools we are going to use:
* Our command line (Terminal)
* ~A text editor (like [Atom](https://atom.io/)).~
* A text editor is no longer necessary but if you're on Windows you might need to [install perl](https://www.perl.org/get.html).

## Setting ruby up
### Updating
In order to run the scripts, we will need to install ruby. Ruby comes pre-installed on MacOS but if you run into issues, [update to the latest version](https://stackify.com/install-ruby-on-your-mac-everything-you-need-to-get-going/).

### Downloading BibleGateway-to-Markdown.rb
Follow the instructions to download and set up [jgclark's BibleGateway-to-Markdown](https://github.com/jgclark/BibleGateway-to-Markdown).

## Usage
### 1. Install scripts
Put both scripts (`bg2md.rb` and `bg2obs.sh`) in the same directory, open your terminal application, and navigate to that directory with commands like the following:

* `pwd` Show your current directory
* `ls` List all contents in the current directory
* `cd` Enter a subdirectory (e.g., `cd Desktop`)
* `cd ..` Brings you 'up' one directory

### 2. Run the script
Once you have navigated to the directory containing both scripts, run `bash bg2obs.sh`. This will run the bash script.

`NOTE`: In this directory, a folder called `Scripture` with subfolders like `01 - Genesis`, `02 - Exodus` and so on will be created.

Several options are available via command-line switches. Type `bash bg2obs.sh -h` at any time to display them.

#### Script option summary
| Option | Description |
| ------ | ----------- |
| `-v [VERSION]` | Specify the version of the Bible to download (default is WEB) |
| `-b` | Set words of Jesus in bold (default is Off)|
| `-e` | Include editorial headers (default is Off)|
| `-a` | Create an alias in the YAML front matter with a more user-friendly chapter title  (e.g., "Genesis 1") (default is Off)|
| `-i` | Show progress information while the script is running (i.e. "verbose" mode) (default is Off)|
| `-h` | Display help |

#### Example usage
| Command | Description |
| ------- | ----------- |
|`bash bg2obs.sh -i -v NIV` | Download a copy of the NIV Bible with no other options.|
|`bash bg2obs.sh -b` | Download a copy of the WEB Bible (default) with Jesus' words in bold. |
|`bash bg2obs.sh -v NET -beai` | Download a copy of the NET Bible with all options enabled.|

### 3. Format the text in a text editor

Some crossreferences are sometimes still included, run `\<crossref intro.*crossref\>` to delete.

**There you go!** Now, just move the "Scripture" folder into your Obsidian vault. You can use the provided `The Bible.md` file as an overview file.

## Translations
This script downloads the [World English Bible](https://worldenglish.bible/) by default. If you want to download a different translation, specify the version using the `-v` command-line switch as documented above. The list of abbreviations is available on the [Bible Gateway](https://www.biblegateway.com) site under the version drop-down menu in the search bar.  Make sure to honour copyright guidelines. The script has not been tested with all versions of the Bible available at Bible Gateway, though most of the more commonly-used ones should work.

A fork of this repo supports Catholic translations: [mkudija/BibleGateway-to-Obsidian-Catholic](https://github.com/mkudija/BibleGateway-to-Obsidian-Catholic).

## Troubleshooting ⚠️
Below are steps to common issues when using the script. If this still doesn't solve your issue, feel free to [get in touch](https://joschuasgarden.com/Contact+me) and I will attempt to fix it!

### Problems loading ruby/gems
An error like this indicates ruby or the gems aren't installed properly: `in require: cannot load such file -- colorize (LoadError)`

**Solutions**
* Have a look at the [bg2md installation guide](https://github.com/jgclark/BibleGateway-to-Markdown/tree/7aaa4cdaba5d8ebb2e7e3fa5ace7de96c1534846#installation) to make sure you installed ruby and gems properly.
* Run the gem install with admin privileges: `sudo gem install colorize optparse clipboard`.
* Re-install ruby and gems.
