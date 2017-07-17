Orbit IO
========

Installation
------------
Requirements:
Following package need to be installed on Odroic C2 board: git gcc. Can use following command to install
```bash
sudo apt install git gcc
```

Use following commands to compile and install Orbit IO
```bash
git clone <repo url> OrbitIO
cd OrbitIO
git submodule init
git submodule update

make

sudo make install
```
