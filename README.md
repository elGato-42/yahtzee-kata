# Yahtzee Scoring Kata

## Overview
Welcome to the Yahtzee Scoring Kata! Your task is to implement a scoring system for the game of Yahtzee. The goal of this exercise is to write clean, well-tested code while considering different approaches and refactoring opportunities.

## Instructions

You are given a function `best_score(roll)` that takes a list of five dice rolls (each a number from 1 to 6) and returns the highest possible score and category for that roll. Your task is to **implement or improve** the function while maintaining correctness.

### Requirements:
- Ensure your code returns the correct score for all Yahtzee scoring categories.
- fork this repo and open a PR with your proposed changes. We will discuss your approach and decisions in an in-person interview.

## Scoring Categories

Yahtzee scoring is divided into **Upper Section** and **Lower Section** categories. The function should evaluate the given dice roll against all categories and return the one that provides the highest score.

### **Upper Section**

| Category  | Scoring Rule |
|-----------|-------------|
| **Ones**  | Sum of all 1s |
| **Twos**  | Sum of all 2s |
| **Threes** | Sum of all 3s |
| **Fours** | Sum of all 4s |
| **Fives** | Sum of all 5s |
| **Sixes** | Sum of all 6s |


### **Lower Section**

| Category  | Scoring Rule |
|-----------|-------------|
| **Three of a Kind** | Sum of all dice if at least three match |
| **Four of a Kind** | Sum of all dice if at least four match |
| **Full House** | 25 points for three of one number + two of another (e.g., 2-2-3-3-3) |
| **Small Straight** | 30 points for four consecutive numbers (e.g., 1-2-3-4) |
| **Large Straight** | 40 points for five consecutive numbers (e.g., 2-3-4-5-6) |
| **Yahtzee** | 50 points for five of a kind (e.g., 5-5-5-5-5) |
| **Chance** | Sum of all dice (no restrictions) |

## Deliverables
- A working implementation of `best_score(roll)`, following the scoring rules above.
- Identify areas for improvement in readability, maintainability, or performance.

## Running Tests
To run the tests, execute:

```sh
ruby yahtzee_scoring_test.rb
```

## Ruby Version

v2.7.0 or higher
