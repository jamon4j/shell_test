#!/bin/sh

add()
{
   a=$1
   b=$2
   z=`expr $1 + $2` 
   echo "the sum is $z"
}

add $1 $2

exit
