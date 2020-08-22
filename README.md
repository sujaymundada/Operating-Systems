# LECTURE 1

OS: Virtual machine that makes hardware easy to program. 

    Tradeoff between convenience for the users to use and efficiency. 

OS is the layer where the hardware and softwares. All applications will interact with the hardware through the OS. 

    System calls are the APIs provided by the OS for the programs to interact with the hardware. 

To increase better use of machine we can do I/O and Computation at the same time. You have multiple hardware resources which you can use simultaneously.

    Multiprogramming: Run more than 1 process at the same time on the CPU. CPU decides memory management and scheduling. 

Shell: Composable commands 

GUI was added to OS wherein you can interact with your OS using the GUI. 

More than 1 process can run on 1 processor using scheduling -- multiprogramming

More than 1 processor can be present on 1 system. Used to do parallel programming. 

# LECTURE 2

    OS = Kernel + lots of software pieces that sit above it. 

Your system = CPU + I/O devices + Networking Ports(Ethernet) + Memory(RAM) + System Bus(That connects all of this)

System bus allows all the componenets to interact with each other. 

    Concurrancy: One thread on a CPU at a time but multiple threads active at the same time.

Concurrancy also needs parallism to truely allow multiple threads work on together on different cores. (Concurrancy vs Parallelism) 

Multiple process running at the same time on OS but only on a single CPU is concurrancy but not parallelism. Its virtual concurrancy.

Assembly language is the language through which you can program your hardware.

All the other programming languages reduce the code to the assembly code at a later stage. 

Hardware Features motivated by OS services:

1. Protection: 

Some assembly instructions are sensitive or previleged and you do not want any arbitary process to run that instruction. E.g. HALT 

All other instructions can be accessed by the other processes. 

This is achieved using User Mode vs Kernel Mode. 

Set a bit that tells you whether you are in User or Kernel Mode.

A status bit in a protected processes register indicates whether you are in the Kernel Mode or not. 

IO is a priveleged mode. But most user processes have IO , so then the processes asks the Kernel to do this process on its behalf. 

    System calls are the OS procedures that execute previleged instructions. 

    System calls are the APIs exported by the kernel. They internally call traps which are software interrupts. 

System calls internally call traps so that the execution is passed onto the kernel to carry out the previleged instructions. 

The trap handler saves the caller process state so it can restore control to the user process context state. 

The processes context state gets saved in the kernel's memory. 

2. Memory Protection 

Any process can read any other processes memory if memory protection is not enabled. 

Thus processes have to be restricted from accessing memory other than their own allocated memory. 

Ranged checks are the simplest way to do it. e.g. Use base and limit registers values and then for each user reference the OS checks if the memory location is between the base and the limit registers. 

Process Memory Layout in Memory

    STACK
    GAP 
    DATA [ HEAP SEGMENT] 
    TEXT [CODE TEXT SEGMENT]

When you allocate more space on stack it grows downwards and when you allocate more memory on the heap it grows upwards and gap decreases. 

    Register = One word of memory managed by the CPU. 

Special Purpose Registers:

1. PC - Program Counter. Points to some part of the text segment where the program is currently executing.
2. SP - Stack Pointer. Points to the end of the stack segment. Or where the stack and the gap segment meets. 
3. FP - Frame Pointer. 

Memory Hierarchy

Register --> L1 Cache ---> L2 Cache ----> RAM ----> Disc -----> Network 

1 cycle ---> 2 cycles ---> 7 cycles ----> 100-----> 40k ------> 

Amount of memory increases as you go to right the speed of it decreases. 

Registers / Main memory is directly managed by the processes itself or the OS that decides. 

Caches however are directly managed by the hardware. ( No explicit management by the OS) 

TRAPS (Hardware feature)

Software interrupts: e.g. Page Fault, int overflow, divide by 0. 

Trap is exception condition that should be handled. Traps are handled by the OS. System calls are a special example of traps. 

How a trap is handled ? 
1. Save the context of the process. 
2. Give the execution access to the Kernel by filling the memory bit. 
3. OS has to decide which trap occured. The trap vector now stores the address of the code that handles a particular trap. 
4. Using the trap vector jump to the particular address given in the vector and start executing the code. 
5. Once you are done give the context back the process and resume the execution of the process. 

    Trap vectors are stored in the kernel address space. 

Modern OS use virtual memory traps for many applications: Debugging , Distributed VM, Copy on Write etc. 

IO CONTROL
1. Each IO device has a little processor/controller that enables it to run autonomously. 
2. CPU issues commands to IO devices and continues. 
3. When the IO device comples it issues back a interrupt to the CPU. 
4. CPU then stops whatever it was doing and processes the interrupt. 

Types of IO
1. Synchronous or blocking IO: The process that issued the IO request waits for the interrupt. 
2. Asynchronous or non blocking IO: The process continues working and later maps the IO results once the IO interrupt is encountered. 
3. Memory Mapped IO 

Interrrupts vs Traps: [ Hardware vs Software ] 

    Interrupts are raised by hardware whereas traps are raised by the software. Interrupt vector serve similar purpose to trap vector. 

Timer and Atomic Instructions:

Timer is used by the OS to get time of the day. 

CPU is protected from being hogged by using the timer instructiong. At the end of each timer instruction the CPU chooses a new process to execute. 

Synchornization:

OS must be able to synchronize the cooperating, concurrant processes. 

To support synch. OS must provide what we call atomic instructions. Architecture must provide short sequence of instructions that execute atomically. 
E.g. read -- modify -- write. 

2 methods to achieve this:
1. Disable interrupt before a sequence -- execute that sequence -- enable interrupts again. 
2. test&set instruction that executes atomically. Check value of a variable and set it to something in 1 CPU cycle. 

Translation Lookaside Buffers or TLBs:

Virtual memory allows users to run programs without loading the entire program in memory at once.

OS must keep a track of which pieces are in which part of physical memory and which pieces are on the disc. 

In order for the pieces of the programs to be located /loaded without any disruption to the program the hardware provides a TLB for a speedy lookup. 

    TLB (Cache) maps the virtual memory / logical memory to the physical memory. 
    Pieces of programs are loaded as and when required. And this programs are run without loading the entire program in memory at once. 

# LECTURE 3

    OS Service          Hardware Support
    Protection          Kernel /User Mode 
    Interrupt           Interrupt Vectors 
    System Calls        Trap instructions 
    I/O                 Interrupts, Memory mapping
    Scheduling          Timer
    Synchronization     Atomic Instructions 
    Virtual Memory      Translational Lookaside Buffers

printf statement which you use in c calls the standard library which implements the printf function. The printf function internally calls write system calls

Typically every system call has a number. System call interface maintains a table indexed according to these numbers. 
E.g. Write system call is just a system call number x for the OS. 

    System call generates trap. Trap causes kernel process to execute. Kernel process takes the system call number and runs the particular process. 

System call generating process and the kernel process are the 2 different processes. 

> How to pass parameters to the Kernel Process ? 
1. Push the parameters to the registers. Only certain number of registers on the system so limitations on the number of parameters. 
2. Put all the parameters on a memory block. Then add the address of the block to the register for the kernel process to read. -- Linux and Solaris
3. Put the parameters on the user process stack. The kernel then figures out the stack using the stack pointer. Since the kernel process is a previleged process it can access any processes stack which is however not true for the user processes who can access their own stack. 

The first method is much faster than the rest 2 because the other 2 load memory from the RAM which is much slower than register. 

OS ARCHITECTURE. 

    Kernel is the protected part of OS that runs in kernel mode and has critical datastructures , scheduling and device drivers and protects these from user processes. 
OS = Kernel + User space APIs. 

1. Monolithic Kernel 
Monolithic process --- The kernel process is a single process. Efficiency standpoint good decision but designing is tough. 
OSX kernel is called xnu. 

2. Layered Approach 
Layered Approach -- Each component of the layer can only interact with the layer above it and the layer below it. 
Modular approach so ease of debugging because to make a change in the layer you need to only know the 2 surrounding layers interaction. 

Network Protocol Stack in most kernel codes is implemented through a layered approach. TCP/IP stack 

3. Microkernel 
Microkernel: Bare minimum kernel code that ensures protection and safety of your kernel code. Other OS functionalities like file system , scheduling , external paging etc. are provided as the user space processes. 

Advantages & Disadvantages of Microkernel: 
1. Safety and More Secure. In monolithic kernel since the components are not isolated you can exploit a bug and get the entire access to the kernel process.2. Issues: Efficiency -- Any component to interact with the other component has to go through the kernel. All the communication is Inter Process Communication which will slow things down. There is a lot of communication between the process and that is a lot of overhead. 

OS-X was also initially tried up as a microkernel architecture. But due to efficiency issue they started pushing some things back into the kernel mode to reduce the IPC overhead. 

4. Modular - All modern OS use this. 
Highly Modular and efficient. Core kernel and then you can extend its functionality that you can import as modules when you boot up. At run times the modules get imported in the process and thus this runs like a single monolithic process. 
Advatages of microkernel -- software engineering benefits and efficiency because of monolithic process. 

/sbin/lsmod tells you how many modules are currently imported to be run into the kernel. 
Modules use the interface that allows you to interact with the kernel. Modules have dependencies also which must be loaded before loading the module. 

When you boot there is a list of module that tells OS which modules have to be loaded. 

PROCESS MANAGEMENT:

    A process is not a program. A process is one instance of the program which includes the program code and the execution context (PC , registers etc.) 
    Process is a dynamic  execution context of a running program. 

Several processes can run the same program but each as a distinct process in its own execution state. 

Process Execution State: 

1. New          OS is setting up the process state 
2. Ready        Ready to run but waiting for the CPU    
3. Running      Executing instructions on the CPU 
4. Waiting      Waiting for an event to complete
5. Terminated   OS is destroying this process. 

New ----> Ready <-----------> Running ------> Terminated 

            <------Waiting------->

# LECTURE 4

    PCB: Process Control Block { Kernel Datastructure } 

The OS allocates a new PCB to each process and places it on a state queue. 

For restoring the variables of a process into the memory load it from the PCB. 

Everything that the OS needs for the process are stored in the PCB. 

There are state queues. New state queue, ready state queue and so on. The processes are moved from 1 queue to another on changing the states. 

The running queue is bounded in length because it is limited by the number of the CPUs in your system. For 4 cores you have 4 members at most in run queue.

CONTEXT SWITCH: 

    Process of switching the CPU from 1 processes to another is called context switch and it is a relatively costly operation.
    When the OS stops the process it saves the current variables and the state of the process in the PCB and loads another process.

This process of switching the CPU from 1 process to another is called context switch. 

Every process is given a t duration time slice. Once the timer (kernel instruction) expires a hardware interrupt is generated and current process stops. 

PROCESS CREATING

    Processes are created by other processes. Thus every process has a parent process that created it except the initial boot up process. 
    Kernel is a common ancestor of all processes as it is the initial process that runs on bootup. 

fork system call creates a new process. The child processes created using the fork call is exactly the mirror of the memory copy of the parent process.

The child process wont start executing from the main because it is a copy of the memory layout of the parent and thus starts executing from the fork call as the PC of the parent process points to the fork call. 

    The only difference between the parent and the child process created using fork is the return value of the fork. 
    fork returns the pid of the child in the parent and returns 0 in the child process. 

The child can start running a completely different program using the exec system call. 

The parent can wait for the child to complete execution or continue running in parallel. 

    Exec loads a new program entirely in the childs memory layout and now it is childs memory layout is replaced by the new process entirely. 

Child processes whose parents died before they finished execution are called orphaned process and by default root becomes their parent process. 

    A process can terminate itself using the exit system call. 
    A process can terminate the child using the kill system call. 

On termination the OS reclaims all the resources assigned to the process. 

System Calls: fork , exec, waitpid , kill , exit. 

COOPERATING PROCESSES:  Processes which are not independent are called cooperating processes. 
1. multiple processes can interact with each other using message passing and shared memory. 
2. send and recieve are the system calls that can be used to send messages across the processes. Used in TCP/IP stack. 

SHARED MEMORY:
Establish a memory mapping between the processes' address space to a named memory object that may be shared across the processes.
The mmap(...) system call helps you with this purpose. 

# LECTURE 5

Long Term Scheduling: Number of jobs executing at once in the primary memory --> You usually would have never hit this limit. 

OS decides the max limit on the number of active processes in the system. OS doesnt allow you to start a new process henceforth. 

Hit when you do a fork bomb. OS makes sure all active processes can make progress and have enough hardware resources. 

Short Term Scheduling: Selection of a process from the ready queue. 

The kernel runs the scheduler atleast when 
1. a process switches from running to waiting 
2. an interrupt occurs 
3. a process is created or terminated 

    Non Preemptive System: The scheduler has to wait for the above condition to occur. That is either the process has to start doing IO or wait for an interrupt to occur for it to stop. Otherwise it completes its execution until the next process is scheduled.

    Preemptive Process: The scheduler can call interrrupt a running system when its time slot expires. 

> How to compare scheduling algorithms ? 
1. CPU Utilization - Percentage of time CPU is busy 
2. Throughput - Number of processes completed per unit time. 
3. Turnaround time - The length of time that a process takes to complete including the waiting time. 
4. Waiting time 
5. Response time - Time when the process is ready to run until its next IO request. 

Schedulers are present in the linux kernel. 

But this is usually picked up by the compiler while starting the kernel. 

    A blocking system call is the one that puts the calling process in waiting state until the event on which the block was called gets completed. 

> Scheduling Policies 

1. FCFS - First Come First Serve.
Preemtive system. If a process makes IO / blocking system call then the next process runs and after that again the first process will continue. 
High average wait time. 

2. Round Robin - Every job is given a time slice which it either utilizes fully or partially if it makes a blocking system call before time ends. 
Simplest preemtive system. 
Every time a new process is scheduled you do a context switch. 
All context switches have a overhead involved with them.
Time Slice too large - Waiting time increases and it approaches to FCFS. Too Small time slice has higher overhead of context switch. 

3. Shortest Job First (SJF) / Shorttest remaining time first (SRTF) 
Schedule the job with least amount of expected CPU time. 
Optimal waiting time. 
Preemptive SJF is called SRTF , non preemtive is called SJF. 
IO bound jobs get preference over CPU bound jobs. 

Disadvantages: 
No way to figure out expected job length. 
Long running CPU jobs can starve. 

4. Multilevel Feedback Queue ( MLFQ) 
Overcomes the problem of predicting the job length of shortest job first. 
Use behaviour of the job in the recent past to predict the future. - Decent Assumption because you will probably stay in a for loop for a while. 

# Lecture 6

Multilevel Feedback Queue [MLFQ] - Approximating shortest job first. 

Prediction of what the process will do given the recent history of the process. After the IO is completed it might become CPU bound and stay like that or while doing IO it will keep doing IO for some more time. 

Multiple queues with different priorities. Use round robin scheduling at every queue by running the jobs in the highest priority queue first. 

Start with the highest priority non empty queue and then start doing round robin in that queue. Once that queue is finished you can move to the next queue.

The time slice is same for 1 queue however across queues it is different. The time slice increases as the queue priority decreases. Higher priority queues have a smaller time slice. 

How is the priority of a process gets decided ? Which queue does it go ? 

1. All new jobs that come into the system for the very first time start with the highest priority. 
2. After the process uses its 1st time slice then schedule it to a queue one priority lower. 
3. If the process doesnt use the entire time slice for e.g. goes for I/O then it goes up 1 priority. 

This can lead to a starvation if the highest priority queue is always filled. 

> For a CPU bound job it will keep on going down in priority level until finished. They will sink and end up in the bottom. 

IO bound jobs will rise as they spend a lot of time doing IO in comparison to computation. IO bound jobs are short in terms of CPU requirement. 

Shortest jobs are the IO bound jobs because they do a little of computation and then do IO. 

This will be unfair if there is a long job and multiple short jobs keep on arriving , the long job will be starved in SJF. Similarly in MLFQ some IO bound job presense will starve the computational jobs.

Solution: Attach a timer with every process and if some job is getting starved for more than t seconds then pump it one priority up , so starving processes can get a chance to run. 

> Lottery Scheduler: Randomized Algorithm. [ Randomized Scheduler ]
Select a random job from the ready queue. Assign multiple tickets to short running jobs so that they become more favourable. To avoid starvation ensure that each job has atleast 1 lottery ticket. 
User gets to decide how many tickets to give to job. E.g. Give 10 tickets to a short job and 1 ticket to a long job. 

## THREADS

A process defines address space, text and resources. 

A thread defines a single sequential executional stream within a process (They have their own PC, stack and registers) 

Threads extract the thread of control information from the process and are bound to a single process. 

All threads have the same process ID but different thread id. 

Each process can have multiple threads of control within it. 
No system calls are required to cooperate amongst the threads.
Simpler than message parsing and shared memory. 

e.g. Producer Consumer problem. The producer thread is different from the consumer thread. 
Both can run simulatenously if you have a multi core machine and thus will achieve true parallelism. 

# Lecture 7

## 2 types of threading packages: User level threads and Kernel level threads 

Kernel Threads: Lightweight process , is a thread that the OS knows about. 

Kernel level thread - Kernel will manage the creation and destrcution and scheduling of the threads for us. 

Switching between Kernel Threads of the same process needs a small context switch. Registers, Program counter and stack pointer needs to be changed. 

Memory Management Information doesnt not need to be changed because multiple threads use the same address space. 

If there are multiple threads in a process each thread gets scheduled separately and thus gets independant time slice from the OS. 

## User Level Threads Library. 

OS only knows about the existence of the process. Thus the OS only schedules the process and not the threads. 
The programmer uses the thread library to manage the threads ( create , delete , synchronize and schedule them) 

After the program is scheduled to run by the CPU the thread library decides which thread to execute. 

Thus the kernel in this case visualizes this process as a single thread process only. 

User level threads are very light weight in nature because all the execution of threads including the creating of threads are function calls unlike kernel threads where it is a kernel switch. 

Switching between user level threads is not a context switch unlike kernel level threads. 

User level thread scheduling is more flexible as well. All thread management calls are library calls and not system calls. 

User level threads however cannot take advantage of the multiple cores because the OS doesnt know how many threads the process has. 

If 1 thread on the user level process blocks for IO the entire process starves till that thread IO gets completed. 

If the OS doesnt support threading then you could use the user level threading library.

> Just as each process has a process id each thread has a thread id associated with it. 

## Synchronization 

Because threads are concurrent bits of code you need to worry about Synchronization.

Locks and Semaphores are important methods to ensure synchronization. 

> Terminology: 
    1. Atomic Instruction: Synchronization 
    2. Mutual Exclusion: Ensure only 1 thread does a particular activity at 1 time. 
    3. Critical Section: Piece of code that only 1 thread can execute at a time. 
    4. Locks: Mechanism to prevent other processes from doing something 

> Busy waiting - Waste CPU cycles doing nothing. 

> Locks give mutual exclusion with 2 methods - acquire and release methods. You have to make sure acquire and release methods atomic instructions. 

> Always acquire the lock before entering the critical section and then release the lock. 

Atomic read-modify-write instructions

test&set instruction - tests the value of the variable and sets it to if not already 1 and returns the old value. 

e.g. while(test&set(variable) == 1) add this segment to all the threads,  test&set returns 0 in the first thread that acquires the lock and thus gets free from the while loop whereas other threads get stuck here for busy waiting. 

You can reduce the busy waiting amount if you use queues for different threads and use guards which will ensure that the CPU is given up if the lock is busy
The guard ensures the shared queue datastructure is protected. 

Threads that are busy waiting are actually sleeping when in the queue and thus dont take up the CPU cycle. 

## Semaphores [ SPECIAL ATOMIC INTEGER VARIABLES ]  

> Useful for mutual exclusion and scheduling constraints. 

> Mutex are binary semaphores that take values 1 and 0. 

Integer value which can be manipulated only using 2 methods. Can be updated only 2 special atomic instructions 

Counting Semaphores - Value varies from 1 to n. Useful when n multiple jobs(threads) can be run in parallel. 

2 methods for Semaphores. Wait - decrements and Signal - increments. 

> Uses of Semaphores: Scheduling constraints. You can make sure that some piece of code foo must always execute after bar is executed. The initial value of the semaphore is set to 0 in this case. 

## MONITORS and CONDITIONAL VARIABLES

Monitor is a class that ties the data , operations and in general the synchronization operations together. 

> Monitors require all the shared data to be private. 

> Monitor guarantees mutual exclusion so only 1 thread at a particular time can call a method on that class. 

> Also since the data is private only 1 particular thread can access the shared data. 

> Conditional Variables allows you to go to sleep inside a critical section and then release the lock. 

> It can temporarily release the mutex lock when it can't continue and then reacquire when it can. 

> Why do you need conditional variables ? Lets say you have a remove method in queue that should always return something. Now if the queue is empty it has to wait for the object to be added in the queue but if the remove method doesnt release the lock on the queue then the new element can never be added in the queue so you go to sleep in the remove methods until the queue is empty and give up the lock. 

    Condition variables enable a thread to sleep inside a critical section by giving up the lock on the critical section. 
    Thread must hold the lock while doing checks on the conditional variable. 
    Use wait for giving up the lock and notify to give a signal to the conditional variable. While queue is empty wait. 

> Conditional variables are internally implemented as a queue of threads that are waiting for some condition to get hit. 


## Lecture 11

> Deadlocks can be prevented by using symmetric codes for all the processes accessing the critical section. 

How does the separation of the exec and the fork call help in running the processes ?  
The functions are such that they allow the code before the exec and after the fork to run such that the variables can be set for the exec setup.   
E.g for redirecting the output to a file the code segment before the execvp closes the stdout and opens the file where the output is to be redirected.   

The Unix Pipes are implemented in a similar fashion but using the pipe system call. It connected the output of one process to a kernel pipe and the input of another process is connected to the same pipe so that the data flows seamlessly.  

Both child and parent process can access the file descriptors set in the parent process but one overwrites the other.  
SIGCONT signal can be sent to the parent process to wait for the execution of the child without using the wait statement.  

- SIGCONT is basically used to resume the execution of a process stopped by SIGSTOP. 










































 





