#Install virtualenv and python3
sudo yum install python37 python3-pip
pip3 install -U virtualenv

python3 -m virtualenv airflow-python-3
cd airflow-python-3 && source bin/activate

set -x
yum -y groupinstall "Development Tools"
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel python3-devel wget cyrus-sasl-devel.x86_64 python3-setuptools gcc-c++

pip3 install apache-airflow
airflow initdb
airflow scheduler -D
airflow webserver -D