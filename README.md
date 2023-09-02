# ASC-Graphs operations
## About
An assembly-based project with the role of introduction to a low level programming language, solving some graphs operations.

## The code
The [Matrix_multiplication.s](Matrix_multiplication.s) file is the *normal* version and the [Matrix_multiplication_dynamic.s](Matrix_multiplication_dynamic.s) is the *memory optimised* version.

The code is made to solve 3 tasks:
1. The resulting matrix from an adjacency list;
   The input looks like this:
   ```
   1
   4
   2
   2
   1
   0
   1
   2
   2
   3
   3
   ```
<img width="785" alt="Screenshot 2023-09-02 at 00 46 29" src="https://github.com/TaviF24/ASC-Matrix_multiplication_with_dynamic_memory_allocation/assets/118764142/6873329e-b876-4071-9a97-50bec67830aa">

The output for this input is
```
  0 1 1 0
  0 0 1 1
  0 0 0 1
  0 0 0 0
```


2. The number of **k-length** paths between 2 nodes;
   The input looks like this:
   ```
   2
   4
   2
   0
   1
   2
   2
   3
   3
   2
   0
   3
   ```
<img width="785" alt="Screenshot 2023-09-02 at 01 04 15" src="https://github.com/TaviF24/ASC-Matrix_multiplication_with_dynamic_memory_allocation/assets/118764142/6d64f9b1-ccf0-4a67-be44-557b00a2fd40">

The output for this input is
```
2
```

3. The number of **k-length** paths between 2 nodes using dynamic memory allocation.
For this task, you can use the same input as before, changing the first number to **3**. The output is the same.


## What I used
- Operating system: Ubuntu 22.04.1 LTS
- Language: Assembly x86 AT&T syntax

## How to run it
First, open the working folder with the terminal. If your operating system is on **64-bit**, you have to run the next command because the code is working on **32-bit operating systems**:
```sudo apt-get install g++-multilib```

After that, run the following command to compile the code:
```gcc --m32 file_name.s -o file_name```
and to run it:
```./file_name```.

If you want to run the programm and read all the input from a file, then run:
```./file_name < input_file.txt```.

> [!NOTE]
> The [input3.txt](input3.txt) file should be run with the [Matrix_multiplication_dynamic.s](Matrix_multiplication_dynamic.s) file.

