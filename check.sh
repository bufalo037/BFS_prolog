#!/bin/bash

let score=0

function run_simple
{
    echo -e "\e[95m\n~~~ Running simple tests ~~~\n\e[39m"

    for i in `seq 1 10`; do
        echo -n "Running test $i.........."
        rm -f output.txt &> /dev/null
        python2 checker.py main.pl teste/simple/in_simple_t"$i".txt &> /dev/null
        
        diff teste/simple/out_simple_t"$i".txt output.txt &> /dev/null
        
        if [ $? -le 0 ]; then
            echo -e "\e[92mOK\e[39m"
			score=$((score+1))
        else
            echo -e "\e[91mWRONG\e[39m"
        fi
    done
}

function run_cyclic
{
    echo -e "\e[95m\n~~~ Running cyclic tests ~~~\n\e[39m"

    for i in `seq 1 5`; do
        echo -n "Running test $i.........."
        rm -f output.txt &> /dev/null
        python2 checker.py main.pl teste/cyclic/in_cyclic_t"$i".txt &> /dev/null
        
        diff teste/cyclic/out_cyclic_t"$i".txt output.txt &> /dev/null
        
        if [ $? -le 0 ]; then
            echo -e "\e[92mOK\e[39m"
			score=$((score+1))
        else
            echo -e "\e[91mWRONG\e[39m"
        fi
    done
}

function run_easy
{
    echo -e "\e[95m\n~~~ Running easy tests ~~~\n\e[39m"

    for i in `seq 1 25`; do
        echo -n "Running test $i.........."
        rm -f output.txt &> /dev/null
        python2 checker.py main.pl teste/easy/in_easy_t"$i".txt &> /dev/null
        
        diff teste/easy/out_easy_t"$i".txt output.txt &> /dev/null
        
        if [ $? -le 0 ]; then
            echo -e "\e[92mOK\e[39m"
			score=$((score+1))
        else
            echo -e "\e[91mWRONG\e[39m"
        fi
    done
}

function run_medium
{
    echo -e "\e[95m\n~~~ Running medium tests ~~~\n\e[39m"

    for i in `seq 1 15`; do
        echo -n "Running test $i.........."
        rm -f output.txt &> /dev/null
        python2 checker.py main.pl teste/medium/in_medium_t"$i".txt &> /dev/null
        
        diff teste/medium/out_medium_t"$i".txt output.txt &> /dev/null
        
        if [ $? -le 0 ]; then
            echo -e "\e[92mOK\e[39m"
			score=$((score+1))
        else
            echo -e "\e[91mWRONG\e[39m"
        fi
    done
}

function run_hard
{
    echo -e "\e[95m\n~~~ Running hard tests ~~~\n\e[39m"

    for i in `seq 1 5`; do
        echo -n "Running test $i.........."
        rm -f output.txt &> /dev/null
        python2 checker.py main.pl teste/hard/in_hard_t"$i".txt &> /dev/null
        
        diff teste/hard/out_hard_t"$i".txt output.txt &> /dev/null
        
        if [ $? -le 0 ]; then
            echo -e "\e[92mOK\e[39m"
			score=$((score+1))
        else
            echo -e "\e[91mWRONG\e[39m"
        fi
    done
}

if [ "$#" -eq 0 ]; then
    run_simple
    run_cyclic
	run_easy
	run_medium
	run_hard
	echo -e "\e[95m\n~~~ Total: "$(($score * 2))"/120 ~~~\n\e[39m"
elif [ "$#" -eq 1 ]; then
    if [ "$1" = "s" ]; then
        run_simple
    elif [ "$1" = "c" ]; then
        run_cyclic
	elif [ "$1" = "e" ]; then
        run_easy
	elif [ "$1" = "m" ]; then
        run_medium
	elif [ "$1" = "h" ]; then
        run_hard
    fi
else
    if [ "$1" = "s" ]; then
        rm -f output.txt &> /dev/null
        python2 checker.py main.pl teste/simple/in_simple_t"$2".txt
        
        printf "\e[93m\nYour output:\n\n"
        cat output.txt
        
        printf "\e[92m\n\nCorrect:\n\n"
        cat teste/simple/out_simple_t"$2".txt
        echo
    elif [ "$1" = "c" ]; then
        rm -f output.txt &> /dev/null
        python2 checker.py main.pl teste/cyclic/in_cyclic_t"$2".txt
        
        printf "\e[93m\nYour output:\n\n"
        cat output.txt
        
        printf "\e[92m\n\nCorrect:\n\n"
        cat teste/cyclic/out_cyclic_t"$2".txt
        echo
	elif [ "$1" = "e" ]; then
        rm -f output.txt &> /dev/null
        python2 checker.py main.pl teste/easy/in_easy_t"$2".txt
        
        printf "\e[93m\nYour output:\n\n"
        cat output.txt
        
        printf "\e[92m\n\nCorrect:\n\n"
        cat teste/easy/out_easy_t"$2".txt
        echo
	elif [ "$1" = "m" ]; then
        rm -f output.txt &> /dev/null
        python2 checker.py main.pl teste/medium/in_medium_t"$2".txt
        
        printf "\e[93m\nYour output:\n\n"
        cat output.txt
        
        printf "\e[92m\n\nCorrect:\n\n"
        cat teste/medium/out_medium_t"$2".txt
        echo
	elif [ "$1" = "h" ]; then
        rm -f output.txt &> /dev/null
        python2 checker.py main.pl teste/hard/in_hard_t"$2".txt
        
        printf "\e[93m\nYour output:\n\n"
        cat output.txt
        
        printf "\e[92m\n\nCorrect:\n\n"
        cat teste/hard/out_hard_t"$2".txt
        echo
    fi
    
fi
