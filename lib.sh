# This file is meant to be sourced from the other shell scripts in this directory

# determine the absolute path to the directory containing the running script
get_script_absolute_dir()
{
    # Relative path of the directory containing this script
    script_dir="$(dirname "$0")"

    # Absolute path of the directory containing the script
    script_absolute_dir="$(cd "${script_dir}" && pwd)"

    echo "${script_absolute_dir}"
}

start_cache()
{
    #Check to see if its already running
    if [ $(docker ps | grep ozp-cache | wc -l) == "0" ]; then
        docker run --name ozp-cache -d redis:3.2-alpine
    fi
}

stop_cache()
{
    docker stop ozp-cache
    docker rm ozp-cache
}
