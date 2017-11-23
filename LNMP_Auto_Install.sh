#!/bin/bash
echo '============================'
echo 'LNMP Auot Install Script'
echo 'Author:Jaydenz'
echo 'Bolg:https://www.jaydenz.cn/'
echo '============================'

#安装前准备及读取系统信息
if [[ $(id -u) != 0 ]]; then #检查是否为root用户
	echo '请以root用户权限执行本脚本！'
	exit 1
fi
bit=$(getconf LONG_BIT) #获取当前系统32/64位数
if [ $bit = 32 ]; then
	echo '你的系统是32位'
elif [ $bit = 64 ]; then
	echo '你的系统是64位'
else
	echo '怎么肥事啊？？好像不支持你的系统诶！'
	exit 2
fi
#判断系统发行版
system(){
	public=$(cat /proc/version | grep -oE '(Debian)|(Red Hat)|(Ubuntu)')
	if [[ $public == 'Ubuntu' ]]; then
        	echo '你的系统发行版是Ubuntu'
			return 33
	elif [[ $public == 'Debian' ]]; then
        	echo '你的系统发行版是Debian'
			return 33
	elif [[ $public == 'Red Hat' ]]; then
        	echo '你的系统发行版是Red Hat'
			return 44
	else
        	echo "你的系统发行版不受支持！"
        exit 3
	fi
}
#创建临时安装目录
if [ ! -e /tmp/src ]; then
	mkdir /tmp/src
fi

#源码包地址
nginx=http://nginx.org/download/nginx-1.12.2.tar.gz
mysql_32=https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQL-5.7/mysql-5.7.17-linux-glibc2.5-i686.tar.gz
mysql_64=https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQL-5.7/mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz
php=http://cn2.php.net/distributions/php-7.1.11.tar.gz

install_nginx(){
	echo '下载Nginx...'
	wget -O nginx.tar.gz $nginx
	if [ $? != 0 ]; then
		echo '下载失败，请检查网络链接或下载地址是否失效！'
		exit 3
	fi
	system
	if [[  $? =  '44'  ]]; then
		yum install -y pcre pcre-devel openssl openssl-devel gcc make gcc-c++
	else
		apt-get install -y  --force-yes openssl libssl-dev  libpcre3 libpcre3-dev fizlib1g-dev  
	fi
	tar -xvf nginx.tar.gz && cd nginx
	groupadd nginx
    useradd -M -g nginx -s /sbin/nologin nginx
    ./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_stub_status_module --user=nginx --group=nginx --with-pcre
	cd /tmp/src
}
install_mysql(){
	echo '下载MySQL...'
	if [ $(getconf LONG_BIT) = 32]; then
		wget -O mysql.tar.gz $mysql_32
		if [ $? != 0 ]; then
			echo '下载失败，请检查网络链接或下载地址是否失效！'
			exit 4
		fi
	else
		wget -O mysql.tar.gz $mysql_64
		if [ $? != 0 ]; then
			echo '下载失败，请检查网络链接或下载地址是否失效！'
			exit 4
		fi
	fi
	system
	if [[  $? =  '44'  ]]; then
		yum -y install make gcc-c++ cmake bison-devel ncurses-devel libaio
	else
		apt-get install -y  --force-yes cmake libncurses5-dev  bison g++
	fi
}
install_php(){
	echo '下载PHP...'
	wget -O php.tar.gz $php
	if [ $? != 0 ]; then
		echo '下载失败，请检查网络链接或下载地址是否失效！'
		exit 3
	fi
	system
	if [[  $? =  '44'  ]]; then
		yum install -y libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel libcurl libcurl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel gmp gmp-devel libmcrypt libmcrypt-devel readline readline-devel libxslt libxslt-devel
    开始编译        
	else
		apt-get install -y  --force-yes 
	fi
	
    ./configure --prefix=/usr/local/php --with-config-file-path=/etc --enable-fpm --with-fpm-user=nginx --with-fpm-group=nginx --enable-inline-optimization --disable-debug --disable-rpath --enable-shared --enable-soap --with-libxml-dir --with-xmlrpc --with-openssl --with-mcrypt --with-mhash --with-pcre-regex --with-sqlite3 --with-zlib --enable-bcmath --with-iconv --with-bz2 --enable-calendar --with-curl --with-cdb --enable-dom --enable-exif --enable-fileinfo --enable-filter --with-pcre-dir --enable-ftp --with-gd --with-openssl-dir --with-jpeg-dir --with-png-dir --with-zlib-dir --with-freetype-dir --enable-gd-native-ttf --enable-gd-jis-conv --with-gettext --with-gmp --with-mhash --enable-json --enable-mbstring --enable-mbregex --enable-mbregex-backtrack --with-libmbfl --with-onig --enable-pdo --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-zlib-dir --with-pdo-sqlite --with-readline --enable-session --enable-shmop --enable-simplexml --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx --with-libxml-dir --with-xsl --enable-zip --enable-mysqlnd-compression-support --with-pear --enable-opcache
	
}



























