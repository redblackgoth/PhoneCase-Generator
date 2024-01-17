#!/bin/bash 

if [ ! -d "build/" ] 
then
    echo "Error: Directory build/ doesn't exist"
fi

#get all phone models and case configs

#change split char to help jq parse the JSON
IFS=""
#fetch phone models from JSON. Strip \r from Windows JSON
presets_jq=($(jq -r '.[] | select(type == "object") | .[] | .phone_model' phone_case.json | tr -d '\r'))
echo "Available phone models:" 
echo $presets_jq
echo
#turn presets into an array, splitting on the newline
IFS=$'\n'
presets=($presets_jq)
unset IFS

#put models and variables on websites
jekyll_data_dir='./docs/_data/'
echo "Copying configs to website"
cp phone_case.json $jekyll_data_dir
premade_models_path='./docs/premade-models/'

#TODO: pull these from the JSON 
#TODO: enable "gamepad" when it works
declare -a case_types=( "phone case" "junglecat" "joycon" )
declare -a case_materials=( "hard" "soft" )
filetype='3mf'
echo "Copying all models"

#loop through all case configs and build models
#TODO: use the build tags in build_vars. Only copy files we made already
for model in "${presets[@]}"; do
    for case_type in "${case_types[@]}"; do
        for case_material in "${case_materials[@]}"; do
            filename="${model} ${case_type} ${case_material}.${filetype}"
            
            echo "Copying - ${filename}"
            
            cp "build/${filename}" $premade_models_path
        done
    done
done

exit;


