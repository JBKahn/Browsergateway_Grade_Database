:
PATH="$PATH:/u/ajr/bin:/usr/newtools/bin"
gradedb=$HOME/gradedb
test -d $gradedb
if [ $? = 1 ];then
    mkdir $gradedb
fi
# gradedb
names=''
grades=0
cat <<\EOF
<html>
<title> Grade Database </title>
<body>
<h1> Grade Database </h1>
EOF

if [ $1 = "main" ]
then
    mkdir $gradedb/$httpvar_numeric_stu
    echo $httpvar_name'\n'$httpvar_program >>$gradedb/$httpvar_numeric_stu/info
    echo $httpvar_numeric_grade >>$gradedb/$httpvar_numeric_stu/grade
fi
if [ $1 = "edited" ]
then
    #if [ $httpvar_numeric_stu = $last_numeric_stu ];then
    echo $httpvar_name'\n'$httpvar_program >$gradedb/$httpvar_numeric_stu/info
    echo $httpvar_numeric_grade >$gradedb/$httpvar_numeric_stu/grade
    #else
        #rm -rf $gradedb/$last_numeric_stu
        #mkdir $gradedb/$httpvar_numeric_stu
        #echo $httpvar_name'\n'$httpvar_program >>$gradedb/$httpvar_numeric_stu/info
        #echo $httpvar_numeric_grade >>$gradedb/$httpvar_numeric_stu/grade
    #fi
fi

if [ `ls -A $gradedb | wc -l` ]
then
echo '<h2> Select a student: </h2>'
for f in $gradedb/*
do
    test -d $f
    if [ $? = 0 ];then
        names=$names'\n'`head -1 $f/info`' ''<a href="'`echo $f | sed 's/.*\///'`'">'`head -1 $f/info`'</a><br>'
        current_grade=`cat $f/grade`
        grades=`expr $grades + $current_grade`
    fi
done
echo $names | sort | sed 's/[a-zA-Z0-9 ]* //'
cat <<\EOF
<br>
EOF
students=`ls -l $gradedb | grep -c "^d.*"`
mean=`expr $grades'0' / $students`
echo 'Mean grade: '`echo $mean | sed 's/\(.$\)/\.\1/'`


echo '<br>'
echo '<br>'
echo '<hr>or<hr>'
fi

test -d $gradedb/$1
if [ $? = 0 ];then
    echo '<h2> Edit a student: </h2>'
    echo '<form method=post action=edited>'
    echo 'Name: <input size=30 name=name value="'`head -1 $gradedb/$1/info`'"> <br>'
    echo 'Student number: '$1
    echo '<input type=hidden name=numeric_stu value="'$1'"><br>'
    echo 'Programme:<input name=program value="'`tail -1 $gradedb/$1/info`'"> <br>'
    echo 'Final grade: <input name=numeric_grade value="'`head -1 $gradedb/$1/grade`'"> <br>'
else
    echo '<h2> Add a student: </h2>'
    echo '<form method=post action=main>'
    echo 'Name: <input size=30 name=name value=""> <br>'
    echo 'Student number: <input name=numeric_stu value=""> <br>'
    echo 'Programme:<input name=program value=""> <br>'
    echo 'Final grade: <input name=numeric_grade value=""> <br>'
fi
cat <<\EOF
<input type=submit>
</form>
</body>
</html>
EOF
