#!/bin/bash

function remove_old_files {
   find src/pages -name "*.html" -type f -delete
}

function generate_css {
   echo "<style>" > src/static/css/layout.css.html
   cat src/static/css/layout.css >> src/static/css/layout.css.html
   echo "</style>" >> src/static/css/layout.css.html
}

function generate_js {
   echo "<script type=\"text/javascript\">" > src/static/js/script.js.html
   cat src/static/js/script.js >> src/static/js/script.js.html
   echo "</script>" >> src/static/js/script.js.html
}

# Syntax in the article :
# [INSERT]
# filename.extension
function insert_code {
   while grep -q "\[INSERT\]" copy.md; do
      # Work with line number to do each case one by one

      line_number=`grep -n -m 1 "\[INSERT\]" copy.md | cut -d: -f 1`
      line_number=$((line_number + 1))

      filename=`sed "$line_number q;d" copy.md`
      extension="${filename##*.}"

      # If the source code file is more than 20 lines, hide it (with js function)
      lenght=`cat $(dirname $1)/$filename | wc -l`
      if [ $lenght -gt 20 ]; then
         # Insert a div tag to make the javascript function work
         sed -i "$line_number s/.*/\\\`\\\`\\\`\n<\/div>/" copy.md
         line_number=$((line_number - 1))
         # Insert the hide/show button + Specify syntax highlighting
         sed -i "$line_number s/.*/<a href=\"javascript:toggle_visibility('$filename');\">$filename<\/a><div id=\"$filename\" style=\"display: none;\">\n\\\`\\\`\\\`$extension/" copy.md
         line_number=$((line_number + 1))
      else
         # Specify syntax highlighting
         sed -i "$line_number s/.*/\\\`\\\`\\\`/" copy.md
         line_number=$((line_number - 1))
         sed -i "$line_number s/.*/\\\`\\\`\\\`$extension/" copy.md
      fi

      # Insert the source code
      sed -i "$line_number r $(dirname $1)/$filename" copy.md
   done
}

# Takes an article (in markdown) and convert it into an .html file
function convert {

   cp $1 copy.md

   # If the article contains source code, insert it
   insert_code $1

   # Convert the .md file with pandoc into a .tmp.html file 
   # This will be the core file, but we need to add the header and the footer to
   # it so it can be the entire .html file
   sed "3d" copy.md | pandoc --ascii -o "$(basename ${1%.md}.tmp.html)"
   cat src/templates/header.html $(basename ${1%.md}.tmp.html) src/templates/footer.html > src/pages/$(basename ${1%.md}.html)
   rm $(basename ${1%.md}.tmp.html)

   # Insert the page's title
   title=`sed -n "1p" copy.md`
   sed -i "s/TITLE/$title - NapNac/g" src/pages/$(basename ${1%.md}.html)

   # Insert inline CSS/JS
   sed -i "/CSS/r src/static/css/layout.css.html" src/pages/$(basename ${1%.md}.html)
   sed -i "/Javascript/r src/static/js/script.js.html" src/pages/$(basename ${1%.md}.html)

   # Transform title into a link to the actual page
   sed -i "s/<h1 id=/<a href=\"\"><h1 id=/" src/pages/$(basename ${1%.md}.html)
   sed -i "s/<\/h1>/<\/h1><\/a>/" src/pages/$(basename ${1%.md}.html)

   # Insert summary of the article (h2 links)
   if grep -q "<em>Modifi&#233; le" src/pages/$(basename ${1%.md}.html); then
      sed -i "/<em>Modifi&#233; le/a <ul id=\"summary\">" src/pages/$(basename ${1%.md}.html)
   else
      sed -i "/<h1 id=/a <ul id=\"summary\">" src/pages/$(basename ${1%.md}.html)
   fi
   sed -i "/<ul id=\"summary\">/a </ul>" src/pages/$(basename ${1%.md}.html)
   if grep -q "<h2 " src/pages/$(basename ${1%.md}.html); then
      grep "<h2 " src/pages/$(basename ${1%.md}.html) > summary.tmp
      sed -i "s/<h2 id=\"/<li><a href=\"\#/g" summary.tmp
      sed -i "s/<\/h.>/<\/a><\/li>/g" summary.tmp
      sed -i "/<ul id=\"summary\">/r./summary.tmp" src/pages/$(basename ${1%.md}.html)
      rm summary.tmp
   fi

   # Move the converted file to its actual location in src/pages/
   location=`sed -n "3p" copy.md`
   mv -v src/pages/$(basename ${1%.md}.html) src/pages/$location

   rm copy.md
}


remove_old_files
generate_css
generate_js

find articles -name '*.md' | \
while read file
do 
   convert $file
done
