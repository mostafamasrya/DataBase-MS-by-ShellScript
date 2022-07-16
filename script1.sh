#!/bin/bash
#main menu
#=================================================
#insert

#Insert(){


#============================
#craete table

CreateTable(){
	echo "please enter ur Table Name ? "

        read tablename
        while find ./ $tablename 2>/dev/null
        do
                echo "name is existed ,type new one "
                echo "please enter ur table name ? "
                read $tablename
        done
touch $tablename
echo "$tablename created successfully "
echo "enter the number of columns "
read columnsNo
counter=1
chk=1
while [ $counter -le $columnsNo ]
do
	
	echo "enter name of column no.$counter"
	read colName
	echo "pls enter column type"

	select choice in "string" "intger"
	do
		case $REPLY in
			1)type="str" ;break ;;
			2)type="int" ; break ;;
			*)echo "invalid number ";;
		esac
	done
	if [ $chk -eq 1 ]

	then
		echo "pls ,is column primary key"

		select choice in "primary key" "not a primary key"
		do
			case $REPLY in
			1)pkey="yes";((chk=$chk+1)); break;exit;;
			2)pkey="no";break;exit;;
			*)echo "invalid number";;
	        	esac
        	done
	fi

        if [ $pkey = "no" ]
	then
		if [ $counter -eq $columnsNo ]
		then
			echo -n -e "$colName:$type:n |\n " >>$tablename
		else
		       	echo -n  "$colName:$type:n | " >>$tablename
		       
		 fi
	 else
		 if [ $counter -eq $columnsNo ]
		 then
			 echo -n -e "$colName:$type:p |\n " >>$tablename
		 else
			 echo -n "$colName:$type:p  | " >>$tablename
		 fi
		 pkey="no"

	 fi


	((counter=$counter+1))
done

       
}


#=====================================================
ListTables(){
	ls -l
}

#=======================================================
DropTable(){
        echo "enter your table name"
        read tablename1
        while [ ! -f  $tablename1 ]
        do
                echo "this table is not exist"
                echo "please enter your table name"
                read tablename1
        done
rm  $tablename1
echo "$tablename1 deleted successfully"
}
#=====================================================

Insert(){
	echo "enter your table name"
	read tabName
	while [ ! -f  $tabName ]
	do
                echo "this table is not exist"
		ls
                echo "please enter your table name"
                read tabName
	done
	
	
	awk '{if (NR ==1 )print $0}' $tabName
	count1=1
	recordsNo=`awk 'END{print NR}' $tabName`
	colsNo=$(awk 'BEGIN{FS="|"}{if(NR==1)print NF-1}' $tabName)
	while [ $count1 -le $colsNo ]
	do
		colName1=$(awk -F"|" '{if (NR==1)print $'$count1'}' $tabName)

		#name:str:n
		echo $colName1 >myfile

		colname=$(awk -F: '{if (NR==1)print $1}' myfile)
		coltype=$(awk -F: '{if (NR==1)print $2}' myfile)
		colkey=$(awk -F: '{if (NR==1)print $3}' myfile)
		echo "insert $colname "
		read value1
		if [ $coltype = 'str' ]
		then
			while [[  $value1 != +([a-zA-Z]) ]]
			do
				echo "please insert string value"
				read value1

			done
			if [ $colkey = 'p' ]
			then
				while [ $(awk -F"|" '{if (NR != 1)print $'$count1'}'$tabName | grep $value1) != "" 2>/dev/null ]
				do
					echo "this value is already exist"
                                        read value1
				done
			fi




			if [ $count1 -eq $colsNo ]
			then
				 echo -n -e "$value1  |\n " >>$tabName
			 else
				 echo -n "$value1    | ">>$tabName
			 fi




		else
			while [[ $value1 != +([0-9]) ]]
			do
				echo "please inser intger value"
				read value1


			done
			if [ $colkey = 'p' ]
			then
				while [ $(awk -F"|" '{if (NR != 1)print $'$count1'}' $tabName | grep $value1) != "" 2>/dev/null ]
				do
					echo "this value is already exist"
                                        read value1
                                done
			fi





			if [ $count1 -eq $colsNo ]
                        then
                                 echo -n -e "$value1  |\n " >>$tabName
                         else
                                 echo -n "$value1     | ">>$tabName
                         fi

		fi








		((count1=$count1 +1))

	done
	

}
#====================================================
SelectColumn(){
	awk -F"|" '{if( NR==1)print $0}' $tabName1
	echo "please enter the number of column"
	read number_col
	noCol=$(awk -F"|" '{if (NR ==1)print NF-1}' $tabName1)
	while [ $number_col -gt $noCol ]
	do
		echo "you have just $noCol columns in this table"
	        read number_col
	done
	awk -F"|" '{print $'$number_col'}' $tabName1
}
#====================================================
SelectRow(){
	echo "please enter the number row"
	read number_row
	noRow=$(wc -l $tabName1)
	(( noRow=$noRow-1)) 2>/dev/null
	while [ $number_row -gt $noRow ]
	do
		echo "you have just $noRow rows in this table"
		read number_row
	done
	((number_row=$number_row+1)) 2>/dev/null
	awk -F"|" '{if (NR=='$number_row')print $0}' $tabName1
}
#=====================================================








#=====================================================
#select

Select(){

	echo "enter your table name"
        read tabName1
        while [ ! -f  $tabName1 ]
        do
                echo "this table is not exist"
                ls
                echo "please enter your table name"
                read tabName1
        done
	select choice in "select all table" "select a column" "select a row " "exit"
	do
		case $REPLY in
			1)cat $tabName1 ;;
			2)SelectColumn ;;
			3)SelectRow ;;
			4)echo "finished" ;break;;
			*)echo "invalid number";;

		esac
	done






}
#====================================================

#=====================================================
delete(){

	echo "enter your table name"
        read tabName
        while [ ! -f  $tabName ]
        do
                echo "this table is not exist"
                ls
                echo "please enter your table name"
                read tabName
        done
	echo "enter row number"
	read row
	noRow=$(wc -l $tabName)
        let noRow=$noRow-1 2>/dev/null
        while [ $row -gt $noRow ]
	
        do
	
                echo "you have just $noRow rows in this table"
                read row
		if [ $row -eq 1 ]
		then
			echo "u can not delete this row"
			read row
		fi
        done


#	col=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$column'")print i}}}' $tabName)
#	while [[ $col ==  "" ]]
#	do
#		echo "not found"
#		read column
#		let col=awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$column'")print i}}}' $tabName

#	done
#	echo "target value "
#	read value
#	val=$(awk 'BEGIN{FS="|"}{if($'$col' =="'$value'")print $'$col'}' $tabName 2>>/dev/null)
#	while [[ $val == "" ]]
#	do
#		echo "not found"
#		read value
#		       let val=awk -F"|" '{if ($'col' == "'$value'")print $'$col'}' $tabName 2>>/dev/null
#	done
#	echo $col $val
#	NR1=$(awk 'BEGIN{FS="|"}{if ($'$col'=="'$val'") print NR}' $tabName)



      sed -i ''$row'd' $tabName
      echo "Row Deleted Successfully"
		

}

#======================================================
update(){
	echo "enter your table name"
        read tabName
        while [ ! -f  $tabName ]
        do
                echo "this table is not exist"
                ls
                echo "please enter your table name"
                read tabName
        done
	echo "enter primary key value"
	read value
#	key=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++)print $i}}' $tabName | grep p |cut -f3 -d:)
        while [[ $(awk -F"|" '{if(NR != 1)print $0}' $tabName | grep $value) == "" ]]
        do
		echo "this value is not exist"
	        read value
        done
	nr=$(awk -F"|" '{if (NR !=1)for(i=1;i<=NF;i++){if($i == '$value')print NR}}' $tabName)
	echo "enter no.of column to be updated"
	read colno
	noCol=$(awk -F"|" '{if (NR ==1)print NF-1}' $tabName)
        while [ $colno -gt $noCol ]
        do
                echo "you have just $noCol columns in this table"
                read colno
        done
	oldvalue=$(awk -F"|" '{if(NR=='$nr')print $0}' $tabName | cut -d"|" -f$colno)



	colName1=$(awk -F"|" '{if (NR==1)print $'$colno'}' $tabName)

                #name:str:n
                echo $colName1 >myfile1

                colname=$(awk -F: '{if (NR==1)print $1}' myfile1)
                coltype=$(awk -F: '{if (NR==1)print $2}' myfile1)
                colkey=$(awk -F: '{if (NR==1)print $3}' myfile1)
                echo "insert new value for $colname "
                read newvalue
                if [ $coltype = 'str' ]
                then
                        while [[  $newvalue != +([a-zA-Z]) ]]
                        do
                                echo "please insert string value"
                                read newvalue

                        done
                        if [ $colkey = 'p' ]
                        then
				while [ $(awk -F"|" '{if (NR != 1)print $'$colno'}'$tabName | grep $newvalue) != "" 2>/dev/null ]
                                do
                                        echo "this value is already exist"
                                        read newvalue
                                done
                        fi
		else
			while [[ $newvalue != +([0-9]) ]]
                        do
                                echo "please inser intger value"
                                read newvalue


                        done
                        if [ $colkey = 'p' ]
                        then
                                while [ $(awk -F"|" '{if (NR != 1)print $'$colno'}' $tabName | grep $newvalue) != "" 2>/dev/null ]
                                do
                                        echo "this value is already exist"
                                        read newvalue
                                done
                        fi
		fi
		sed -i ''$nr's/'$oldvalue'/'$newvalue'/g' $tabName
#		sed -i ''$nr's/'$oldvalue'/'$newvalue'/g' $tabName 2>>./.error.log
		echo "column updated successfully"

}






#======================================================
ConnectMenu(){
	select choice in "Create Table" "List Tables" "Drop Table" "Insert Into Table" "Select from Table" "Delete FRom Table" "Update Table"
do
        case $REPLY in
                1)CreateTable ;  break;;
                2)ListTables ; break  ;;
                3)DropTable ; break ;;
                4)Insert; break ;;
		5)Select; break ;;
		6)delete; break ;;
		7)update ; break ;;

        esac
done

}

PS3="please select a chioce number ? "
CreateDB(){
	echo "please enter ur DB_name ? "

	read name 
	while find ./ $name 2>/dev/null 
	do
		echo "name is existed ,type new one "
		echo "please enter ur DB_name ? " 
		read name
	done
mkdir $name 
}

#list func

ListDB(){
	ls -l | find ./ -type d
}	

#connect to DB func
ConnectDB(){
	ls
	echo "enter your DB name"
        read dbname
	while [ ! -d  $dbname ]
        do
		echo "this DB is not exist"
	        echo "please enter your DB name"
                read dbname	       
	done
echo $dbname	
#cd $dbname/
#source script1.sh

cd /home/mostafamasrya/shlproject/$dbname/ 
ConnectMenu

}

#Drop DB

DropDB(){
	echo "enter your DB name"
        read dbname1
        while [ ! -d  $dbname1 ]
        do
                echo "this DB is not exist"
                echo "please enter your DB name"
                read dbname1
        done
rm -ir $dbname1
echo "$dbname1 deleted successfully"
}




select choice in "Create DataBase" "List DataBase" "Connect To DataBase" "Drop DataBase"
do
	case $REPLY in
		1)CreateDB ;  break;;
		2)ListDB  ; break  ;;
		3)ConnectDB ; break ;;
		4)DropDB ; break ;;
	esac
done









