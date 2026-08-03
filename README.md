# ⚙️ x86 Assembly Pstring Library & Jump Table Architecture

## 📌 Overview
This repository contains an x86 Assembly implementation of a **Pstring (Pascal String)** manipulation library, paired with an Assembly-based **Jump Table (switch-case architecture)**. Developed as part of the **Computer Architecture** course at Bar-Ilan University.

Unlike traditional C-strings (null-terminated), Pstrings store their length in the first byte, requiring tailored Assembly logic for memory traversal, string comparison, and mutation operations.

## ✨ Features
* **Pstring Operations (`pstring.s`):**
  * `pstrlen`: Computes string length based on the length header byte.
  * `replaceChar`: Replaces all occurrences of a character within the string.
  * `pstrcpy`: Copies substring within specified index bounds (`i` to `j`).
  * `pstrcmp`: Lexicographically compares two Pstrings within specified bounds.
* **Jump Table Architecture (`func_select.s`):**
  * Low-level `switch-case` dispatch table implemented in Assembly using indirect jumps.
* **C Interoperability (`main.c` & `pstring.h`):**
  * Seamless linkage between C standard input/output routines and Assembly function calls.

## 🛠️ Tech Stack & Concepts
* **Languages:** x86 Assembly (AT&T syntax), C
* **Build System:** Makefile (`gcc`)
* **Concepts:** Computer Architecture, Low-Level Memory Layout, Jump Tables, String Manipulation, Stack Frames & Calling Conventions

## 🚀 How to Run
1. Clone the repository:
   ```bash
   git clone [https://github.com/fatimas11/x86-assembly-pstring-library.git](https://github.com/fatimas11/x86-assembly-pstring-library.git)
