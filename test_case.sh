#!/bin/sh

echo "input a month(1-12)"
read month

case "$month" in
1)
    echo "January" ;;
2)
    echo "Febuary" ;;
3)
    echo "March" ;;
4)
    echo "April" ;;
5)
    echo "May" ;;
6) 
    echo "June" ;;
7)
    echo "July" ;;
8)
    echo "August" ;;
9)
    echo "September" ;;
10)
    echo "October" ;;
11)
    echo "November" ;;
12)
    echo "December" ;;
esac

exit 0
