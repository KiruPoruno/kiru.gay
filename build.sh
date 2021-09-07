#!/bin/sh

SITE="${SITE:-src}"
DEST="${DEST:-build}"
TITLE="${TITLE:-Title}"

[ "$1" != "" ] && SITE="$1"

rm -rf "$DEST"/*
mkdir "$DEST"/blog "$DEST"/tmp -p

write() {
cat <<EOF > "$DEST"/$2/$(echo $i | sed 's/\..*//g' | xargs basename).html
<html>
	<head>
		<title>$TITLE</title>
		%%header.html%%
	</head>
	<body>
		<main>
			%%navbar.html%%
			$(cat $1 | pandoc)
			%%footer.html%%
		</main>
	</body>
</html>
EOF
}

for i in "$SITE"/*.md; do write $i;done
for i in "$SITE"/posts/*.md; do	write $i "blog";done
for i in $(ls -tu "$DEST"/blog); do
	echo "<a href="blog/$i">$i</a>" >> "$DEST"/tmp/entries.html
done

for i in $(ls $PWD/"$DEST"/*.html $PWD/"$DEST"/blog/*.html); do
	grep -oE %%.*.%% "$i" | while read ii; do
		REPLACE="$(echo $ii | sed -e 's/\%/\\\%/g' -e 's/\//\\\//g')"
		FILE="$(echo $ii | sed 's/\%//g')"
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
