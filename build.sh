#!/bin/sh

rm -rf build/* tmp/*
mkdir build/blog -p

for i in src/*.md; do
	FILE="$(echo $i | sed 's/\..*//g' | xargs basename)"
cat <<EOF > build/$FILE.html
<html>
	<head>
		<title>Kiru</title>
		%%header.html%%
	</head>
	<body>
		<main>
			%%navbar.html%%
			$(cat $i | pandoc)
			%%footer.html%%
		</main>
	</body>
</html>
EOF
done


for i in $(ls $PWD/build/*.html); do
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

cp src/resources/* build
