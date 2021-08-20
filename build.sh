#!/bin/sh

rm -rf build/*
mkdir build/blog -p

cp src/*.html build

for i in $(ls $PWD/build/*.html); do
	grep -oE %%.*.%% "$i" | while read ii; do
		REPLACE="$(echo $ii | sed -e 's/\%/\\\%/g' -e 's/\//\\\//g')"
		FILE="$(echo $ii | sed 's/\%//g')"
		sed -e "/$REPLACE/{r src/resources/$FILE" -e 'd}' -i "$i"
	done
done

cp src/resources/* build
