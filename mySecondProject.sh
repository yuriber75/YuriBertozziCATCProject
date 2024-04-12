#!/bin/bash

# Function to calculate the salary in July
calculate_july_salary() {
    local salary_january=$1
    local percentage_increase=$2
    local manager=$3

    if [[ $manager -eq 1 ]]; then
        echo "$(echo "scale=2; $salary_january * 1 + $salary_january * $percentage_increase / 100" | bc)"
    else
        echo "$salary_january"
    fi
}

# Function to calculate the initial salary or if the level is increased
calculate_january_salary() {
    local starting_salary=$1
    local starting_level=$2
    local level=$3

    echo "$(echo "scale=2; $starting_salary * (1.5 ^ ($level - 1))" | bc -l)"
}

# Function to calculate the January salary if the level is the same as the previous year
calculate_january_salary_same_level() {
    local salary_july=$1
    local percentage_increase=$2

    echo "$(echo "scale=2; $salary_july * 1 + $salary_july * $percentage_increase / 100" | bc)"
}

# Function to generate the salary table for the next 20 years
generate_salary_table() {
    local starting_salary=$1
    local starting_level=$2
    local percentage_increase=$3
    local manager=$4

    local current_year=2024
    local level=$starting_level
    local salary_january=""
    local salary_july=""

    echo "Year       | Level    | January Salary  | July Salary (if manager)"

    for (( year=0; year<20; year++ )); do
        if (( ($year + 1) % 4 == 0 )) && (( $level < 10 )); then
            level=$((level + 1))
        fi

        if (( $year == 0 )); then
            salary_january=$(calculate_january_salary $starting_salary $starting_level $level)
            salary_july=$(calculate_july_salary $salary_january $percentage_increase $manager)
        else
            if (( $level == $starting_level )); then
                salary_january=$(calculate_january_salary_same_level $salary_july $percentage_increase)
            else
                starting_level=$level
                salary_january=$(calculate_january_salary $starting_salary $starting_level $level)
            fi
            salary_july=$(calculate_july_salary $salary_january $percentage_increase $manager)
        fi

        echo " Year $current_year | Level: $level | January: $salary_january | July: $salary_july"

        current_year=$((current_year + 1))
    done
}

# Main script
clear

read -p "Enter the starting salary: " starting_salary
read -p "Enter the starting level (from 1 to 10): " starting_level
read -p "Enter the annual percentage increase (from 2 to 5): " percentage_increase
read -p "Is the employee a manager? (y/n): " manager_input

manager=0
if [[ $manager_input == "y" ]]; then
    manager=1
fi

generate_salary_table $starting_salary $starting_level $percentage_increase $manager

