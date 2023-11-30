#!/bin/bash
#----------------------------------------------------------------------------------
# This script runs Jonathan clark's bg2md.rb ruby script and formats the output
# to be useful in Obsidian. Find the script here: https://github.com/jgclark/BibleGateway-to-Markdown
#
# It needs to be run in the same directory as the 'bg2md.rb' script and will output
# one .md file for each chapter, organising them in folders corresponding to the book.
# Navigation on the top and bottom is also added.
#
#----------------------------------------------------------------------------------
# SETTINGS
#----------------------------------------------------------------------------------
# Setting a different translation:
# Using the abbreviation with the -v flag, you can call on a different translation.
# It defaults to the "World English Bible", if you change the translation,
# make sure to honour the copyright restrictions.
#----------------------------------------------------------------------------------

usage()
{
	echo "Usage: $0 [-beaicyh] [-v version] [-s secondary_translations]"
	echo "  -v version   Specify the main translation to download (default = WEB)"
	echo "  -s secondary_translations   Specify one or more secondary translations separated by space"
	echo "  -b    Set words of Jesus in bold"
	echo "  -e    Include editorial headers"
	echo "  -a    Create an alias in the YAML front matter for each chapter title"
	echo "  -i    Show download information (i.e. verbose mode)"
	echo "  -c    Include inline navigation for the breadcrumbs plugin (e.g. 'up', 'next','previous')"
	echo "  -y    Print navigation for the breadcrumbs plugin (e.g. 'up', 'next','previous') in the frontmatter (YAML)"
	echo "  -h    Display help"
	exit 1
}

pad_string() {
    local input=$1
    local length=$2
    printf "%-${length}s" "${input}"
}

draw_progress_bar() {
    # Arguments: book current_progress total
    local book=$1
    local current_progress=$2
    local total=$3
    local padded_book="$(pad_string "$book" 20)"
    let _progress=(${current_progress}*100/${total}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
    _done=$(printf "%${_done}s")
    _left=$(printf "%${_left}s")
    printf "\rBook: ${padded_book} Progress: [${_done// /#}${_left// /-}] ${_progress}%%"
}

# initial empty array for secondary_translations
secondary_translations=()

# Process command line args
while getopts 'v:s:beaicy?h' c
do
	case $c in
		v) main_translation=$OPTARG ;;
		s) secondary_translations+=("$OPTARG") ;; # append to array
		b) boldwords="true" ;;
		e) headers="true" ;;
		a) aliases="true" ;;
		i) verbose="true" ;;
		c) breadcrumbs_inline="true" ;;
		y) breadcrumbs_yaml="true" ;;
		h|?) usage ;; 
	esac
done

# Shift out the options and args until we get to the argument of -s
shift $((OPTIND-1))

# All remaining parameters are considered as arguments of -s
secondary_translations+=("$@")

# Copyright disclaimer
echo "I confirm that I have checked and understand the copyright/license conditions for ${translation} and wish to continue downloading it in its entirety.?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done


all_translations=("$main_translation")
for translation in "${secondary_translations[@]}"
do
    all_translations+=("$translation")
done

# Initialize variables
book_counter=0 # Setting the counter to 0
book_counter_max=66 # Setting the max amount to 66, since there are 66 books we want to import

# Book list
declare -a bookarray # Declaring the Books of the Bible as a list
declare -a abbarray # Delaring the abbreviations for each book. You can adapt if you'd like
declare -a lengtharray # Declaring amount of chapters in each book

# -------------------------------------------
# TRANSLATION: Lists of Names
# -------------------------------------------
# For Translation, translate these three lists. Seperated by space and wrapped in quotes if they include whitespace.
# Name of "The Bible" in your language
biblename="The Bible"
# Full names of the books of the Bible
bookarray=(Genesis Exodus Leviticus Numbers Deuteronomy Joshua Judges Ruth "1 Samuel" "2 Samuel" "1 Kings" "2 Kings" "1 Chronicles" "2 Chronicles" Ezra Nehemiah Esther Job Psalms Proverbs Ecclesiastes "Song of Solomon" Isaiah Jeremiah Lamentations Ezekiel Daniel Hosea Joel Amos Obadiah Jonah Micah Nahum Habakkuk Zephaniah Haggai Zechariah Malachi Matthew Mark Luke John Acts
Romans "1 Corinthians" "2 Corinthians" Galatians Ephesians Philippians Colossians "1 Thessalonians" "2 Thessalonians" "1 Timothy" "2 Timothy" Titus Philemon Hebrews James "1 Peter" "2 Peter" "1 John" "2 John" "3 John" Jude Revelation)
# Short names of the books of the Bible
abbarray=(Gen Ex Lev Num Deut Josh Judg Ruth "1 Sam" "2 Sam" "1 Kgs" "2 Kgs" "1 Chr" "2 Chr" Ezra Neh Esth Job Ps Prov Eccles Song Isa Jer Lam Ezek Dan Hos Joel Amos Obad Jonah Mic Nah Hab Zeph Hag Zech Mal Matt Mark Luke John Acts Rom "1 Cor" "2 Cor" Gal Eph Phil Col "1 Thess" "2 Thess" "1 Tim" "2 Tim" Titus Philem Heb James "1 Pet" "2 Pet" "1 John" "2 John" "3 John" Jude Rev)
# -------------------------------------------

# Book chapter list
lengtharray=(50 40 27 36 34 24 21 4 31 24 22 25 29 36 10 13 10 42 150 31 12 8 66 52 5 48 12 14 3 9 1 4 7 3 3 3 2 14 4 28 16 24 21 28 16 16 13 6 6 4 4 5 3 6 4 3 1 13 5 5 3 5 1 1 1 22)

# Initialise the "The Bible" file for all of the books
echo -e "# ${biblename}\n" >> "${biblename}.md"
## Secondary Translations
all_translations_arr_length=${#all_translations[@]}

for ((trans_counter=0; trans_counter<all_translations_arr_length; trans_counter++))    # For each translation
  do
        translation=${all_translations[${trans_counter}]}
        
        echo "Starting download of ${translation} Bible."


      for ((book_counter=0; book_counter <= book_counter_max; book_counter++))
      do
          book=${bookarray[$book_counter]}
          maxchapter=${lengtharray[$book_counter]}
          abbreviation=${abbarray[$book_counter]}

          for ((chapter=1; chapter <= maxchapter; chapter++))     # For each chapter
          do
              draw_progress_bar "$book" $chapter $maxchapter

              filename="${abbreviation} ${chapter}"

              ((prev_chapter=chapter-1))
              ((next_chapter=chapter+1))
              prev_file="${abbreviation} ${prev_chapter}"
              next_file="${abbreviation} ${next_chapter}"
              same=""

              # If not the main translation then include Prefix like NLT John 10 for easy search and include link to main translation as same.
              if [[ $translation != $main_translation ]] ; then
                  filename="${translation} ${filename}"
                  prev_file="${translation} ${prev_file}"
                  next_file=" ${translation} ${next_file}"
                  same="same:: [[${abbreviation} ${chapter}]]"
              fi

            # Call the ruby command with necessary customization here for secondary translations
              if [[ $boldwords = "true" && $headers = "false" ]] ; then
                  text=$(ruby bg2md.rb -e -c -b -l -v "${translation}" "${book} ${chapter}") # This calls the 'bg2md_mod' script
              elif [[ $boldwords = "true" && $headers = "true" ]] ; then
                  text=$(ruby bg2md.rb -c -b -l -v "${translation}" "${book} ${chapter}") # This calls the 'bg2md_mod' script
              elif [[ $boldwords = "false" && $headers = "true" ]] ; then
                  text=$(ruby bg2md.rb -e -c -l -v "${translation}" "${book} ${chapter}") # This calls the 'bg2md_mod' script
              else
                  text=$(ruby bg2md.rb -e -c -l -v "${translation}" "${book} ${chapter}") # This calls the 'bg2md_mod' script
              fi

              # Formatting Navigation and omitting links that aren't necessary


              if [[ ${maxchapter} = 1 ]] ; then
                # For a book that only has one chapter
                navigation="up:: [[${book}]]"
              elif [[ $chapter = $maxchapter ]] ; then
                # If this is the last chapter of the book
                navigation="up:: [[${book}]]\nprevious:: [[${prev_file}|← ${book} ${prev_chapter}]]"

              elif [[ $chapter = 1 ]] ; then
                # If this is the first chapter of the book
                navigation="up:: [[${book}]]\nnext:: [[${next_file}|${book} ${next_chapter} →]]\n$same"
              else
                # Navigation for everything else
                navigation="up:: [[${book}]]\nprevious:: [[${prev_file}|← ${book} ${prev_chapter}]] | next:: [[${next_file}|${book} ${next_chapter} →]]\n$same"
              fi
              
              # Construct YAML front matter for the secondary translations
              yaml="---\nAliases: []\n---\n"

              text=$(echo "$text" | sed 's/^(.*?)v1/v1/') # Deleting unwanted headers

              
              export="${yaml}${navigation}${text}"



              # Export for secondary translation verses
              echo -e "$export" >> "$filename.md"

              folder_name="${book}" # Setting the folder name

              # Create a folder for the translation if it doesn't exist, otherwise move new file into existing folder
              mkdir -p "./Scripture/${translation}/${folder_name}"; mv "${filename}".md "./Scripture/${translation}/${folder_name}"
          done

          echo ""
      


        if [[ $translation == $main_translation ]] ; then
              # Create an overview file for each book of the Bible:
              overview_file="links: [[${biblename}]]\n# ${book}\n\n[Start Reading →]([[${abbreviation} 1]])"
              echo -e $overview_file >> "$book.md"
              mv "$book.md" "./Scripture/${translation}/${folder_name}"

              # Append the bookname to "The Bible" file
              echo -e "* [[${book}]]" >> "${biblename}.md"
        fi
        


        done
done
# Tidy up the Markdown files by removing unneeded headers and separating the verses
# with some blank space and an H6-level verse number.
#
# Using a perl one-liner here in order to help ensure that this works across platforms
# since the sed utility works differently on macOS and Linux variants. The perl should
# work consistently.

if [[ $verbose = "true" ]] ; then
	echo ""
	echo "Cleaning up the Markdown files."
fi

find . -name "*.md" -print0 | xargs -0 perl -0777 -pi -e 's/#### About\n.*\n\n.*Preferences//gs'
# Clear unnecessary headers
find . -name "*.md" -print0 | xargs -0 perl -pi -e 's/#.*(#####\D[1]\D)/#$1/g'

# Format verses into H6 headers
find . -name "*.md" -print0 | xargs -0 perl -pi -e 's/#####\s(\d+)(.*)(\n)?/\n##### $1\n$2\n\n/'

# Delete crossreferences
find . -name "*.md" -print0 | xargs -0 perl -pi -e 's/\<crossref intro.*crossref\>//g'

if [[ $verbose = "true" ]]; then
echo "Download complete. Markdown files ready for Obsidian import."
fi
