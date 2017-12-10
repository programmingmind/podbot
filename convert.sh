#!/bin/bash
for d in `find podcasts -type d -maxdepth 1 -mindepth 1 | cut -d / -f 2`
do
    if [ ! -f ./podcasts/$d/out.wav ]; then
        node decodeOpus.js $d
        node processFragments.js $d
        files=( $(find podcasts/$d -type f ! -name "*.*" ! -name "*-tmp*") )
        numIn=${#files[@]}
        COMMAND="ffmpeg"
        for f in "${files[@]}"
        do
            COMMAND="$COMMAND -f s16le -ar 48k -ac 2 -i $f"
        done
        COMMAND="$COMMAND -filter_complex amix=inputs=$numIn podcasts/$d/out.wav"
        echo $COMMAND
        eval ${COMMAND}
    fi
done
