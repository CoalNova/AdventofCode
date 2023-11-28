for folder in ./src/20**; do 
    for filename in $folder/??.zig; do 
        cp ./src/day.template.zig $filename; 
        done 
    done