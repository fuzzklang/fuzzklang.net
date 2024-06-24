SERVER_URL_AND_HOST=""
DOCKER_NETWORK_NAME=""
DOCKER_DEFAULT_PORT=""

source ./.env

if [ ! $SERVER_URL_AND_HOST  ] || [ ! $DOCKER_NETWORK_NAME ] || [ ! $DOCKER_DEFAULT_PORT ]; then
    echo "Missing env variables, exiting."
    exit
fi

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

while getopts "hd:n:r" OPTION
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
        r)
        RESTART_ONLY="true"
        ;;
    esac
done

if [ ! $WORKDIR ] || [ ! $SERVICE_NAME ]; then
    usage
    exit
fi

function deploy_service() {
    cd $WORKDIR;

    if [ ! -d "./deploy" ]; then
        mkdir deploy;
    fi

    if [ ! $RESTART_ONLY ]; then
        docker build -t $SERVICE_NAME:latest . &&
        docker save -o ./deploy/$SERVICE_NAME.tar $SERVICE_NAME &&
        echo "Copying image to server"
        scp deploy/$SERVICE_NAME.tar $SERVER_URL_AND_HOST:$SERVICE_NAME.tar &&
        echo "Removing old image" ;
        ssh $SERVER_URL_AND_HOST "docker image rm $SERVICE_NAME 2>/dev/null " &&
        echo "Loading new image" ;
        ssh $SERVER_URL_AND_HOST "docker load < $SERVICE_NAME.tar"
    fi &&
    echo "Stopping and removing old container" ;
    ssh $SERVER_URL_AND_HOST "docker stop $SERVICE_NAME 2>/dev/null && docker rm $SERVICE_NAME 2>/dev/null" ;
    echo "Starting new container" ;
    ssh $SERVER_URL_AND_HOST "docker run --name $SERVICE_NAME --network $DOCKER_NETWORK_NAME -p $DOCKER_DEFAULT_PORT -it -d $SERVICE_NAME";
}


function print_runtime_env () {
    echo "Service name:      $SERVICE_NAME"
    echo "Working directory: $WORKDIR"
    echo "Port:              $DOCKER_DEFAULT_PORT"
    echo "Restart only:      $RESTART_ONLY"
}

print_runtime_env

deploy_service


