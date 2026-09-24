#!/usr/bin/env bash

#
# Each post produces a single HTML page (<folder>.html);
# the source for a post is in a single folder (listed
# below, newest first), consisting of
#
#       'meta.txt'       - three lines: title, date (YYYY-MM-DD), summary
#       'contents.html'  - a table of contents
#       '[1-99]*.md'     - the main body of the post
#       'x-footnotes.md' - the footnotes for the post
#
# index.html is the blog's front page: a list of every
# post, built from the meta.txt files.
#
# Requires pandoc (https://pandoc.org).
#

posts=('fluxo-de-notas')

FN=x-footnotes.md
TEMP=temp.html

cp header.html index.html
echo '        <ol id="posts">' >> index.html

for i in "${posts[@]}"; do
    title=$(sed -n 1p $i/meta.txt)
    date=$(LC_ALL=C date -d "$(sed -n 2p $i/meta.txt)" '+%B %-d, %Y')
    summary=$(sed -n 3p $i/meta.txt)

    # Post page
    pandoc $i/[0-99]*.md $i/$FN -o $TEMP
    cp header.html $i.html
    echo '        <p id="back-top"><a href="./">← Todas as notas</a></p>' >> $i.html
    echo "        <p id=\"title-info\">by Maga, $date.</p>" >> $i.html
    cat $i/contents.html >> $i.html
    cat $TEMP >> $i.html
    echo '<p id="back"><a href="./">← Todas as notas</a></p>' >> $i.html
    rm $TEMP

    # Entry on the front page
    cat >> index.html <<ENTRY
            <li>
                <a href="$i.html">$title</a>
                <span class="post-date">$date</span>
                <p class="post-summary">$summary</p>
            </li>
ENTRY
done

echo '        </ol>' >> index.html
