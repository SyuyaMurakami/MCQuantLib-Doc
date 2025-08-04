DIR=$(cd $(dirname $0) && pwd)
cd $DIR
sphinx-apidoc -f -o ./source ./MCQuantLib
sleep 3