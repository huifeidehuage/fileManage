#! /bin/bash --login

##环境设置
K=2
##提供的函数或功能
# dir     查看当前目录下所有文件
# create  建立文件
# entitle 文件权限控制
# open    打开文件
# close   关闭文件
# Read    读写文件
# write   写文件
# delete  删除文件
# quit    退出文件系统





#命令检查器
function match()
{
	for i in create delete open close Read write clean quit dir entitle
	do

		if test "$i" = "$1"
		then 
			 return 1
		fi
	done
	return 0	
}
#文件操作的函数
function clean()
{
	clear
}
function dir()
{
	ls
}
function entitle()
{	
	if test -z $1
	then 
		echo "缺少文件名"
		return
	fi

	if ! test -r $1 -o  -w $1  -o  -x $1
	then
		echo "文件$1不存在"
		return
	fi

	echo "选择修改的模式 0=收回权限 1=赋予权限 "
	read mode

	if test "$mode" -eq 0
	then 
		echo "选择收回的权限 r=可读 w=可写 x=可执行"
		read entitlement
		for i in r w x
		do
			if test $i = $entitlement
			then
				chmod u-$entitlement $1
				echo "权限收回成功"
				return
				
			fi
		done
	fi
	if test "$mode" -eq 1
	then
		echo "选择赋予的权限 r=可读 w=可写 x=可执行"
		read entitlement
		for i in r w x
		do
			if test $i = $entitlement
			then
				chmod u+$entitlement $1
				echo "权限赋予成功"
				return
			fi
		done
	fi
}

function create()
{	
	#echo "文件名不合法"
	if test -z $1
	then 
		echo "缺少文件名"
		return
	fi
	if test -f $1    #如果文件存在且为普通文件则退出函数
	then echo "文件$1已存在"
	else 
		touch $1
		echo "文件创建成功"
	fi	

}

function delete()
{
	if test -z $1
	then 
		echo "缺少文件名"
		return
	fi

	if ! test -r $1 -o  -w $1  -o  -x $1
	then
		echo "文件$1不存在"
		return
	fi
	rm $1
}

function open()
{
	if test -z $1
	then 
		echo "缺少文件名"
		return
	fi

	if ! test -r $1 -o  -w $1  -o  -x $1
	then
		echo "文件$1不存在"
		return
	fi
	
	if test $k -ge $K
	then echo "打开的文件个数超出限制"
	else
		if test -r $1       #判断文件是否可读
		then
			echo "$1文件已打开,文件内容如下"
			cat $1
			let "k++"
		else
			echo "您对该文件没有读权限"
		fi
	fi
}

function close()
{
	if test -z $1
	then 
		echo "缺少文件名"
		return
	fi

	if ! test -r $1 -o  -w $1  -o  -x $1
	then
		echo "文件$1不存在"
		return
	fi

	echo "$1文件已关闭"
	
	if test "$k" -gt 0
	then let "k--"
	fi
}

function Read()
{
	if test -z $1
	then 
		echo "缺少文件名"
		return
	fi

	if ! test -r $1 -o  -w $1  -o  -x $1
	then
		echo "文件$1不存在"
		return
	fi

	if test -r $1
	then 
		if test -w $1
		then 
			vim $1
		else
			echo "文件不可写"
			cat $1
		fi
	else
		echo "您没有打开该文件的权限，它不可读"
	fi
}

##写文件  若文件存在且可读写，则使用vim操作；
##       若文件存在且只可写，则提供写入模式；
##       若文件存在且只可读，则提示不可写
##       若文件不存在，     则提示文件不存在
function write()
{	
	if test -z $1
	then 
		echo "缺少文件名"
		return
	fi

	if test -f $1   #判断要写入的文件是否存在
	then
		if test -w $1
		then
			if test -r $1
			then 
				vim $1
			else
				echo "请选择您要输入的模式 1-追加  2-覆盖"d
				read mode
				while test "$mode" -ne 1 -a "$mode" -ne 2 
				do
					echo "输入的模式不正确,重新输入"
					read mode
				done
				if test "$mode" -eq 1
				then
					echo "请输入你要写入文件的数据"
					read data
					echo "$data" >> $1
				else
					echo "请输入你要写入文件的数据"
					read data
					echo "$data" > $1
				fi
			fi
		else
			echo "文件不可写"
		fi
	else
		echo "文件$1不存在"
	fi		
}

function quit()
{
	echo "账户登出"
	exit
}


#############
#创建一级文件目录，里面存放一个文件用来当作主目录文件MFD
if test -d MFD
then cd MFD
else (mkdir MFD ; cd MFD)
fi

#登录界面
echo "New user? yes or no!"
read kind
end="end"
temp="0"
while test "$end" = "end"
do
	#echo "New user? yes or no!"
	#read kind
	if test "$kind" = "yes"
	then
		echo "账户注册"
		echo -e "username: \c"
		read user
		for i in `cat MFD.txt`
		do
			#echo "$i "
			if test "$i" = "$user"
			then 
				echo "账号已存在"
				temp="1"
				break
			fi 
		done
		#echo "$temp"
		if test "$temp" #-eq 1 
		then 
			temp=""
			continue
		fi
		stty -echo
		echo "账号名可用"
		echo -e "password: \c"
		read password
		echo "   "
		stty echo
		echo "$user" >> MFD.txt
		mkdir "$user"
		echo "$password" >> $user/UFD.txt
		echo "账号注册成功，请重新登录"
	fi
    while true
	do
		echo -e 'login: \c'
		read user
		stty -echo
		echo -e 'Password:\c'
		read password
		echo "   "
		stty echo
		
		#用户注册功能随后再说

		#访问MFD判断用户登录是否合法
		if 
			grep -xF "$user" MFD.txt>>MFD.log
		then 
			cd "$user"
			if grep -xF "$password"  UFD.txt>>UFD.log 
			then
				echo "登录成功"
				end="hah"
				break
			else 
				echo "密码错误"
				cd ..
				continue
			fi
		else echo "$user账户不存在"
		fi
	done
done
#用户界面
pwd
k=0   #记录打开的文件数
while true
do
	echo -e "\033[40;33;5m $user-Lenovo-B40-70: \c"
	echo -e "\033[49;37;5m \c"
	read command filename
	match $command
	if test "$?" -eq "0"
	then
		echo "未知命令"
		continue
	fi
	$command $filename
done

















