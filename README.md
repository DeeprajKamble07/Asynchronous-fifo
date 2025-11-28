# Asynchronous-fifo

This project implements an Asynchronous FIFO (First-In-First-Out) memory buffer in Verilog, designed for transferring data safely between two different clock domains (write clock wclk and read clock rclk).
It includes full/empty detection, overflow/underflow flags, Gray code pointer synchronization, and a testbench to verify FIFO behavior.

Key Features:
Dual-Clock Support
Write operations occur on wclk, Read operations occur on rclk

Gray Code Pointers
Used for safe pointer transfer between domains:
Convert binary wptr → wptr_g, Convert binary rptr → rptr_g

Two-Stage Synchronizers: 
Reduces metastability when receiving opposite-domain pointers:
wptr_g_s1, wptr_g_s2 — write pointer synchronized to read domain, rptr_g_s1, rptr_g_s2 — read pointer synchronized to write domain

FIFO Status Logic:
Empty when synchronized write pointer = read pointer, Full based on Gray-code MSBs and LSBs, Overflow flagged when writing into a full FIFO, Underflow flagged when reading from an empty FIFO, Valid asserts when a valid read occurs
