#!/bin/sh

read -p "please input x y" x y
z=`expr $x + $y`
echo "The sum is $z"

exit
