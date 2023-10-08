WORKDIR=""
NAME=""
PORT=""
NETWORK=""

while getopts "w:dn:p:k:" OPTION
do
  case $OPTION in
    w)
      WORKDIR=$OPTARG
      ;;
    d)
      DETACHED="-d"
      ;;
    n)
      NAME=$OPTARG
      ;;
    p)
      PORT=$OPTARG
      ;;
    k)
      NETWORK=$OPTARG
  esac
done

if [ ! -d $WORKDIR ]; then
  echo "Invalid working directory"
  echo "Exiting".
  exit
fi

cd $WORKDIR

if [ $NETWORK ]; then
  NETWORK="--network $NETWORK"
else
  echo "Warning, no network specified"
fi

if [ $PORT ]; then
  PORT="-p $PORT"
fi

if [ $NAME ]; then
  NAME_OPT="--name $NAME"
fi

docker build -t $NAME . ;
docker run -it --rm $PORT $DETACHED $NAME_OPT $NETWORK $NAME
