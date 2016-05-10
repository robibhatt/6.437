unzip upload.zip -d ./to_be_removed
add matlab
matlab -nodesktop -tty -nosplash -r "matlab_wrapper; exit;"
rm -rf ./to_be_removed
