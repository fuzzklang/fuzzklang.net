ROOT=$(pwd)
NETWORK_NAME="nginx.net"

function usage () {
    echo "Script to deploy a specified service to fuzzklang.net."
    echo "Requires docker."
    echo ""
    echo "Usage:         bash run.sh -d <source_directory> -n <service_name> [-x] "
    echo "-h (help):     Print this help note."
    echo "-d:            Source directory for service. Requires a Dockerfile."
    echo "-n:            Name for service. Is passed to Docker."
    echo "-r:(optional): Restart only. Skips copying of docker image to server."
}

while getopts "hd:n:xp" OPTION
    do
    case $OPTION in
        h)
        usage
        exit
        ;;
        d)
        WORKDIR=$OPTARG
        ;;
        n)
        SERVICE_NAME=$OPTARG
        ;;
        x)
        RESTART_ONLY="true"
        ;;
        p)
        PORT="-p $OPTARG"
        ;;

    esac
done

function deploy_service() {
    cd $WORKDIR;

    if [ ! -d "./deploy" ]; then
        mkdir deploy;
    fi

    if [ ! $RESTART_ONLY ]; then
        docker build -t $SERVICE_NAME:latest . &&
        docker save -o ./deploy/$SERVICE_NAME.tar $SERVICE_NAME &&
        echo "Copying image to server"
        scp deploy/$SERVICE_NAME.tar root@fuzzklang.net:$SERVICE_NAME.tar &&
        echo "Removing old image" ;
        ssh root@fuzzklang.net "docker image rm $SERVICE_NAME 2>/dev/null " &&
        echo "Loading new image" ;
        ssh root@fuzzklang.net "docker load < $SERVICE_NAME.tar"
    fi &&
    echo "Stopping and removing old container" ;
    ssh root@fuzzklang.net "docker stop $SERVICE_NAME 2>/dev/null && docker rm $SERVICE_NAME 2>/dev/null" ;
    echo "Starting new container" ;
    ssh root@fuzzklang.net "docker run --name $SERVICE_NAME --network $NETWORK_NAME $PORT -it -d $SERVICE_NAME";
}


function print_runtime_env () {
    echo "Service name:      $SERVICE_NAME"
    echo "Root:              $ROOT";
    echo "Working directory: $WORKDIR"
    echo "Port:              $PORT"
    echo "Restart only:      $RESTART_ONLY"
}

print_runtime_env

deploy_service


