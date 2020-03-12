echo "enter the  first number..?"
read fn
echo "enter the second number ??"
read sn
echo "/////////////////////////////////////////////////////"
echo "...............MENU......................."
echo "-----------------------------------------------------"
echo " + ADD "
echo " - SUB "
echo " * MUL "
echo " / DIV "
echo "/////////////////////////////////////////////////"
echo "enter the operater"
read opr
if test $opr = "+"
then 
        r=`expr $fn + $sn `
	echo "sum of two no: = $r "
elif test $opr = "-"
then 
	r=`expr $fn - $sn `
	echo "sub of two no: = $r "
elif test $opr = "x"
then 
	r=`expr $fnq \* $sn `
	echo "mul of two no: = $r "
elif test $opr = "/"
then 
	r=`expr $fn / $sn `
	echo "div of two no: = $r "
else
	echo "invalude operater"
fi
