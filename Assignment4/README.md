# Assignment 4

## Objective

In the past assignments, you have written LLVM passes to conduct static and dynamic program analysis.
In this assignment, we will be exploring the use of other forms of program analysis, using concolic execution and fuzz testing.
You will be using two different (and popular open-source) program analysis tools - [KLEE](http://klee.github.io/) and [AFL](https://github.com/AFLplusplus/AFLplusplus) - on two different programs.
You will be documenting your experience by answering the following questions in the form of a written experience report.


## Setup

1. Make sure you have compiled KLEE with uClibC enabled. If not, please recompile it again with the following command.
```
cmake -DENABLE_SOLVER_Z3=ON -DENABLE_UNIT_TESTS=OFF -DENABLE_SYSTEM_TESTS=OFF -DZ3_INCLUDE_DIRS=$HOME/z3/build/include -DENABLE_TCMALLOC=OFF -DHAVE_Z3_GET_ERROR_MSG_NEEDS_CONTEXT=ON -DENABLE_POSIX_RUNTIME=ON -DENABLE_KLEE_UCLIBC=ON -DKLEE_UCLIBC_PATH=$HOME/klee-uclibc -DLLVMCC=$HOME/llvm-project/build/bin/clang -DLLVMCXX=$HOME/llvm-project/build/bin/clang++ ..
```
2. You will also need to ensure that clang has compiler runtime libraries (`compiler-rt`) enabled. If not, recompile `clang` with the following. If you have recompiled clang, please also recompile AFL.
```
cmake -G Ninja ../llvm -DLLVM_ENABLE_PROJECTS="tools;clang;compiler-rt" -DLLVM_TARGETS_TO_BUILD="host"  -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_OPTIMIZED_TABLEGEN=ON -DCMAKE_BUILD_TYPE=Release
```


## Tasks

For simplicity, we have divided your experience report into smaller tasks.
There is no "wrong" answer for the responses, as long as you can show that you have tried different scenarios, and explain your reasons articulately.
You may include screenshots to complement your explanations.

1. * A) Prepare `PasswordCheck.c` for KLEE. (5 marks for code, 20 marks for short answers)
       * i. Instrument the program for KLEE. You should identify the appropriate variables to be made symbolic.
       * ii. Restrict the state space so that KLEE only checks for lowercase alphabetic characters (a-z) for the string input.
       * iii. You may assume that the input text will not exceed 16 characters.
       * iv. Please submit this modified file as `KLEE1.c`. (5 marks)
   * B) Run KLEE on the modified program, with default options.
        ```bash
          clang -emit-llvm -S -c KLEE1.c -o KLEE1.ll
          klee KLEE1.ll
        ```
       * i. How many bugs are detected by KLEE? Explain the nature of all detected bug(s). If not, explain why no bugs were found. (3 marks) 
       * ii. How many total paths were explored by KLEE? (3 marks)
       * iii. Approximately, how long did KLEE take to run? (2 marks)
       * iv. Why is KLEE considered a concolic execution tool rather than a pure symbolic execution tool? What are the differences? (2 marks)
   * C) Now apply a sanitizer, by passing in `fsanitize=signed-integer-overflow` when building `KLEE1.c`.
       * i. What is the effect on KLEE by applying this sanitizer, compared to your previous observations without sanitizers? Is KLEE able to find any new bugs? Does KLEE explore additional paths? Does KLEE take longer to run? (6 marks)
       * ii. How does a sanitizer work? (4 marks)

2. * A) Prepare `PasswordCheck.c` for AFL. (5 marks for code, 20 marks for short answers)
       * i. Instrument the program for AFL. You should identify which variables should be read from STDIN.
       * ii. Restrict the state space so that AFL only checks for lowercase alphabetic characters (a-z) for the string input.
       * iii. You may assume that the input text will not exceed 16 characters.
       * iv. Please submit this modified file as `AFL1.c`. (5 marks)
   * B) Run AFL on the modified program, with default options. You must supply an input folder with seed files. Start with minimal number of seed files.
        ```bash
          afl-clang-fast -g AFL1.c -o AFL1
          afl-fuzz -i input -o output -m none -- ./AFL1 @@
        ```
       * i. How many crashes and hangs were encountered by AFL? (3 marks)
       * ii. How many bugs are detected by AFL? Explain the nature of all detected bug(s). If not, explain why no bugs were found. (2 marks)
       * iii. How long did AFL take to encounter its first crash or hang, if one was ever found? (2 marks)
   * C) Now apply sanitizers to AFL, by passing in `fsanitize=signed-integer-overflow, address, undefined`.
       * i. How many crashes and hangs were detected by AFL, with sanitizers, compared to the program without sanitzers? (3 marks)
       * ii. How many bugs are detected by AFL? Explain the nature of all detected bug(s). If not, explain why no bugs were found. (2 marks)
       * iii. Try modifying the seed input files, and/or adding more input seed files. Does this change the AFL results in any way? (3 marks)
       * iv. Having used both KLEE and AFL on the same program, which tool do you find more effective in finding bugs in this scenario? What are the advantages and disadvantages of using each tool respectively? (5 marks)

3. * A) Prepare `Vulnerable.c` for KLEE. (5 marks for code, 15 marks for short answers)
       * i. Instrument the program for KLEE.
       * ii. Please submit this modified file as `KLEE2.c`. (5 marks)
   * B) Run KLEE on the modified program, with the (uClibc) C standard library enabled.
       * i. Explain your observations from using KLEE on this program. Your response should document (but not limited to) (10 marks).
            * Number and types of bugs found
            * Number of paths
            * The time taken
       * ii. Try fixing a few bug(s) in the program, and recompiling the program again. Then, run KLEE on it again. Do you discover any new bugs or paths? (5 marks)

4. * A) Prepare `Vulnerable.c` for AFL. (5 marks for code, 25 marks for short answers)
       * i. Instrument the program for AFL so that it uses shared memory.
       * ii. Please submit this modified file as `AFL2.c`. (5 marks)
   * B) Run AFL on the modified program.
       * i. Explain your observations from using AFL on this program and try different sanitizers. (10 marks)
       * ii. Try fixing a few bugs(s) in the program, and running AFL on it again. Do you discover any new bugs or paths? (5 marks)
       * iii. Plot a graph that shows the number of error cases (i.e., bugs, crashes, hangs) detected by AFL versus the elapsed time. (5 marks)
       * iv. Compare the results using KLEE and AFL on `Vulnerable.c`. Which tool is preferrable for bug detection? What are the advantages and drawbacks of using each tool? (5 marks)


#### Deliverable(s):

1. Four `.c` source files: `KLEE1.c`, `KLEE2.c`, `AFL1.c`, `AFL2.c`.

2. A single PDF file named `report.pdf` that contains your responses to the tasks above. 


## Evaluation Rubric

Your report will be evaluated on the quality of your responses to each prescribed task.
The length of a response does not imply higher quality - a high quality response demonstrates that you have articulately (and consisely) explained your observations and have considered different scenarios.
One way to help explain your observations is to use small examples.
Ideally, your report should explain the effectiveness of each program analysis tool on two different programs to a software developer who is not familiar with program analysis.

```
20% - Modified code for the tools
80% - Written experience report (containing your responses to each task)
```


## Additional Resources

1. A series of helpful video tutorials for KLEE:
   [Part 1](https://www.youtube.com/watch?v=z6bsk-lsk1Q)
   [Part 2](https://www.youtube.com/watch?v=BDvNDw2jsSs)
   [Part 3](https://www.youtube.com/watch?v=XLtoWNbnfK0)
   [Part 4](https://www.youtube.com/watch?v=XaYEmwVMRt4)

2. [AFL injection](https://github.com/AFLplusplus/AFLplusplus/blob/stable/instrumentation/README.persistent_mode.md)


## Submission Instructions

#### Notes:
- Please push your deliverables in the **A4_Submit** folder in the **master** branch by the deadline.
- Do not rename the submission folder.
- Points will be deducted if you have more deliverables than requested.

## Deadline:

A snapshot of your submission folder will be automatically taken by the following deadline:

- Friday, March 25, 2022 23:59:00 PST

