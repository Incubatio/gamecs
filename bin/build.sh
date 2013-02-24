SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR 
cd ..
#ROOT_DIR=`pwd`

R_PATH=`which r.js`
node $R_PATH -o baseUrl=./lib/gamejs name=gamejs out=gamejs.min.js
