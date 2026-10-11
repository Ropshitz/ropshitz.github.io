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

posts=('maimonides-thursdays' 'fluxo-de-notas')

# pages that are built but not listed on the front page
unlisted=('iniciais-teste')

FN=x-footnotes.md
TEMP=temp.html

months=(jan fev mar abr mai jun jul ago set out nov dez)

# cache-busting version for the css/js links, so browsers never mix old and new files
V=$(cat main.css desktop.css script.js | md5sum | cut -c1-8)
sed "s/__V__/$V/g" header.html > index.html
cat >> index.html <<HEAD
        <p class="list-heading">Todas as notas</p>
        <p class="ornament">❦</p>
        <ol id="posts">
HEAD

for i in "${posts[@]}" "${unlisted[@]}"; do
    title=$(sed -n 1p $i/meta.txt)
    iso=$(sed -n 2p $i/meta.txt)
    date=$(LC_ALL=C date -d "$iso" '+%B %-d, %Y')
    day=$(date -d "$iso" '+%-d')
    month="${months[$(( $(date -d "$iso" '+%-m') - 1 ))]} $(date -d "$iso" '+%Y')"
    summary=$(sed -n 3p $i/meta.txt)

    # Post page
    pandoc --lua-filter=dropcap.lua $i/[0-99]*.md $i/$FN -o $TEMP
    sed "s/__V__/$V/g" header.html > $i.html
    echo '        <p id="back-top"><a href="./">← Todas as notas</a></p>' >> $i.html
    echo "        <p id=\"title-info\">by Maga, $date.</p>" >> $i.html
    cat $i/contents.html >> $i.html
    cat $TEMP >> $i.html
    echo '<p id="back"><a href="./">← Todas as notas</a></p>' >> $i.html
    rm $TEMP

    # unlisted pages get no entry on the front page
    if [[ " ${unlisted[*]} " == *" $i "* ]]; then continue; fi

    # Entry on the front page
    cat >> index.html <<ENTRY
            <li>
                <a class="post" href="$i.html">
                    <time class="post-date" datetime="$iso">
                        <span class="post-day">$day</span>
                        <span class="post-month">$month</span>
                    </time>
                    <span class="post-title">$title</span>
                    <span class="post-summary">$summary</span>
                </a>
            </li>
ENTRY
done

cat >> index.html <<FOOT
        </ol>
        <p class="list-footer">⁂</p>
FOOT
