#!/bin/sh

SITE="${SITE:-src}"
DEST="${DEST:-build}"
TITLE="${TITLE:-Title}"

[ "$1" != "" ] && SITE="$1"

rm -rf "$DEST"/*
mkdir "$DEST"/blog "$DEST"/tmp -p

write() {
	FILE="$DEST/$2/$(echo "${i%.*}" | sed 's/ /-/g' | tr "[:upper:]" "[:lower:]" | xargs basename | sed 's/^\w*-//g').html"
cat <<EOF > "$FILE"
<html>
	<head>
		<title>$TITLE</title>
		%%header.html%%
	</head>
	<body>
		<main>
			%%navbar.html%%
			$(cat "$1" | pandoc)
			%%footer.html%%
		</main>
	</body>
</html>
EOF

	touch -d "$(date -Rr "$i")" "$FILE"
}

for i in "$SITE"/*.md; do write "$i";done
for i in "$SITE"/posts/*.md; do	write "$(echo "$i" | sed 's/^\w* //g')" "blog";done
ls "$SITE"/posts | grep -E '*.md' | sort -r | while read i; do
	LINK="$(echo $i | tr "[:upper:]" "[:lower:]" | sed -e 's/^\w* //g' -e 's/ /-/g' -e 's/.md/.html/g')"
	echo "<br><div><a href="blog/$LINK">$(echo ${i%.*} | sed 's/^\w* //g')</a><br>Last modified: $(date -r "$SITE/posts/$i" +%Y-%m-%d\ -\ %I:%M:%S)</div>" >> "$DEST"/tmp/entries.html
done

for i in $(ls $PWD/"$DEST"/*.html $PWD/"$DEST"/blog/*.html); do
	grep -oE %%.*.%% "$i" | while read ii; do
		REPLACE="$(echo $ii | sed -e 's/\%/\\\%/g' -e 's/\//\\\//g')"
		FILE="$(echo $ii | sed -e 's/\%//g' -e 's/ /-/g' | tr '[:upper:]' '[:lower:]')"
		[ -f "$SITE/resources/$FILE" ] && {
			sed -e "/$REPLACE/{r $SITE/resources/$FILE" -e 'd}' -i "$i"
		}
		[ -f ""$DEST"/tmp/$FILE" ] && {
			sed -e "/$REPLACE/{r "$DEST"/tmp/$FILE" -e 'd}' -i "$i"
		}
	done
done

for i in $(ls $PWD/"$DEST"/*.html $PWD/"$DEST"/blog/*.html); do
	grep -oE "\|\|\|.*.\|\|\|" "$i" | while read ii; do
		REPLACE="$(echo $ii)"
		COMMAND="$(echo $ii | sed 's/|||//g')"
		sed "s#$REPLACE#$(eval $COMMAND | sed -e 's/\#/\\#/g')#g" -i "$i"
	done
done

rm "$DEST"/tmp -rf
cp "$SITE"/resources/* "$DEST"
