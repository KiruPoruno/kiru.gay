#!/bin/sh

rm -rf build/*
mkdir build/blog build/tmp 

write() {
cat <<EOF > build/$2/$(echo $i | sed 's/\..*//g' | xargs basename).html
<html>
	<head>
		<title>Kiru</title>
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

for i in src/*.md; do write $i;done
for i in src/posts/*.md; do	write $i "blog";done
for i in $(ls -tu build/blog); do
	echo "<a href="blog/$i">$i</a>" >> build/tmp/entries.html
done

for i in $(ls $PWD/build/*.html $PWD/build/blog/*.html); do
	grep -oE %%.*.%% "$i" | while read ii; do
		REPLACE="$(echo $ii | sed -e 's/\%/\\\%/g' -e 's/\//\\\//g')"
		FILE="$(echo $ii | sed 's/\%//g')"
		[ -f "src/resources/$FILE" ] && {
			sed -e "/$REPLACE/{r src/resources/$FILE" -e 'd}' -i "$i"
		}
		[ -f "build/tmp/$FILE" ] && {
			sed -e "/$REPLACE/{r build/tmp/$FILE" -e 'd}' -i "$i"
		}
	done
done

rm build/tmp -rf
cp src/resources/* build
